process.env.NODE_ENV = 'test'
utils           = require './utils.e2e.db'
chai            = require 'chai'
expect          = require('chai').expect
should          = chai.should()
chaiAsPromised  = require 'chai-as-promised'
chai.use chaiAsPromised

elem   = {}

# TODO reinstate signup tests when signup page goes live
describe 'eeosk auth.signup', () ->

  before (done) ->
    elem =
      alert:        element byAttr.css '.alert'
      email:        element byAttr.model 'email'
      email_check:  element byAttr.model 'email_check'
      password:     element byAttr.model 'password'
      username:     element byAttr.model 'username'
      submit:       element byAttr.css 'button[type="submit"]'

    utils.reset(browser)

  it 'should show signup page', () ->
    browser.get '/create-online-store'
    browser.getTitle().should.eventually.equal 'Create your store | eeosk'

  it 'should notify if validations fail', () ->
    # Alert should not initially be displayed
    elem.alert        .isDisplayed().should.eventually.equal false
    # Test for matching emails
    elem.email        .sendKeys utils.random_user.email
    elem.email_check  .sendKeys utils.random_user.email + 'z'
    elem.password     .sendKeys utils.random_user.password.substr(0,6)
    elem.username     .sendKeys utils.random_user.username
    elem.submit       .click()
    elem.alert        .isDisplayed().should.eventually.equal true
    elem.alert        .getText().should.eventually.equal 'Emails don\'t match'
    # Test for short password
    elem.email_check  .clear().sendKeys utils.random_user.email
    elem.submit       .click()
    elem.alert        .isDisplayed().should.eventually.equal true
    elem.alert        .getText().should.eventually.equal 'Password must be at least 8 characters'
    # Test for short store name
    elem.password     .sendKeys 'baz'
    elem.username     .clear().sendKeys 'shrt'
    elem.submit       .click()
    elem.alert        .isDisplayed().should.eventually.equal true
    elem.alert        .getText().should.eventually.equal 'Store name must be between 5 and 25 characters'
    # Test for valid store name
    elem.username     .clear().sendKeys('àëį@#$%^&*()_=+`"<>.?,/\\|{}[]~\' store 123').getAttribute('value').should.eventually.equal 'store123'
    elem.username     .clear().sendKeys('cool-store-')
    elem.submit       .click()
    elem.alert        .isDisplayed().should.eventually.equal true
    elem.alert        .getText().should.eventually.equal 'Store name must begin and end with a letter or number'
    # Test for redirect to welcome screen upon success
    elem.username     .clear().sendKeys utils.random_user.username
    elem.submit       .click()
    # Logged in
    browser           .getTitle().should.eventually.equal 'Build your store | eeosk'
    browser           .manage().getCookie('loginToken')
    .then (cookie) ->
      cookie          .value.should.have.string('Bearer%20')

  it 'should not allow duplicate signups', () ->
    utils.log_out()
    browser.get '/create-online-store'
    # Test for duplicate email
    elem.alert        .isDisplayed().should.eventually.equal false
    elem.email        .sendKeys utils.random_user.email
    elem.email_check  .sendKeys utils.random_user.email
    elem.password     .sendKeys utils.random_user.password
    elem.username     .sendKeys 'another-username'
    elem.submit       .click()
    elem.alert        .isDisplayed().should.eventually.equal true
    elem.alert        .getText().should.eventually.equal 'email must be unique'
    # Test for duplicate username
    elem.email        .sendKeys '.uk'
    elem.email_check  .sendKeys '.uk'
    elem.username     .clear().sendKeys utils.random_user.username
    elem.submit       .click()
    elem.alert        .isDisplayed().should.eventually.equal true
    elem.alert        .getText().should.eventually.equal 'username must be unique'
    browser           .getTitle().should.eventually.equal 'Create your store | eeosk'

  xit 'should click confirmation link in email', () ->

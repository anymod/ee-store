process.env.NODE_ENV = 'test'
utils           = require './utils.e2e.db'
chai            = require 'chai'
expect          = require('chai').expect
should          = chai.should()
chaiAsPromised  = require 'chai-as-promised'
chai.use chaiAsPromised

entry = {}
elem  = {}

describe 'eeosk auth.login', () ->

  before (done) ->
    elem =
      alert:        element byAttr.css '.alert'
      email:        element byAttr.model 'email'
      email_check:  element byAttr.model 'email_check'
      password:     element byAttr.model 'password'
      username:     element byAttr.model 'username'
      submit:       element byAttr.css 'button[type="submit"]'
    utils.delete_all_tables()
    utils.create_user(utils.random_user)

  it 'should show message on invalid login', () ->
    browser         .manage().deleteAllCookies()
    browser.get '/login'
    elem.alert      .isDisplayed().should.eventually.equal false
    elem.email      .sendKeys utils.random_user.email
    elem.password   .sendKeys 'foobar'
    elem.submit     .click()
    elem.alert      .isDisplayed().should.eventually.equal true
    elem.alert      .getText().should.eventually.equal 'Invalid email or password'
    elem.email      .clear().sendKeys 'foo@bar.co.uk'
    elem.password   .clear().sendKeys utils.random_user.password
    elem.submit     .click()
    elem.alert      .isDisplayed().should.eventually.equal true
    elem.alert      .getText().should.eventually.equal 'Invalid email or password'

  it 'should allow login, navigation, and logout', () ->
    browser         .manage().deleteAllCookies()
    browser.get '/login'
    browser         .getTitle().should.eventually.equal 'Login | eeosk'
    elem.email      .sendKeys utils.random_user.email
    elem.password   .sendKeys utils.random_user.password
    elem.submit     .click()
    browser         .getTitle().should.eventually.equal 'Build your store | eeosk'
    browser         .manage().getCookie('loginToken')
    .then (cookie) ->
      # Logged in
      cookie        .value.should.have.string('Bearer%20')
      browser       .get '/storefront/blog'
      browser       .getTitle().should.eventually.have.string 'Build your store'
      browser       .get '/catalog'
      browser       .getTitle().should.eventually.have.string 'Add products'
      browser       .get '/orders'
      browser       .getTitle().should.eventually.have.string 'orders'
      browser       .get '/account'
      browser       .getTitle().should.eventually.have.string 'Account'
      browser       .get '/logout'
      # Logged out
      browser       .getTitle().should.eventually.have.string 'Logged out'
      browser       .manage().getCookie('loginToken')
    .then (cookie) ->
      should.not.exist(cookie)

  it 'should not allow app visits when logged out', () ->
    browser         .manage().deleteAllCookies()
    browser         .get '/storefront/home'
    browser         .getTitle().should.eventually.equal 'Login | eeosk'
    browser         .get '/catalog'
    browser         .getTitle().should.eventually.equal 'Login | eeosk'
    browser         .get '/orders'
    browser         .getTitle().should.eventually.equal 'Login | eeosk'
    browser         .get '/account'
    browser         .getTitle().should.eventually.equal 'Login | eeosk'

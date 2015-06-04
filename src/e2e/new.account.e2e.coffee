process.env.NODE_ENV = 'test'
utils           = require './utils.e2e.db'
chai            = require 'chai'
expect          = require('chai').expect
should          = chai.should()
chaiAsPromised  = require 'chai-as-promised'
chai.use chaiAsPromised
_               = require 'lodash'

elem    = {}
scope   = {}

describe 'eeosk account', () ->

  before (done) ->

    elem =
      body:                   element byAttr.css 'body'

    utils.reset_and_login(browser)
    .then (res) ->
      scope = res
      scope.categories = ['All'].concat _.unique(_.pluck scope.products, 'category')
    .then () -> utils.create_products([21..150])

    ## TODO Add these tests to signed in account functionality
    # # Test for short store name
    # elem.password     .sendKeys 'baz'
    # elem.username     .clear().sendKeys 'shrt'
    # elem.submit       .click()
    # elem.alert        .isDisplayed().should.eventually.equal true
    # elem.alert        .getText().should.eventually.equal 'Store name must be between 5 and 25 characters'
    # # Test for valid store name
    # elem.username     .clear().sendKeys('àëį@#$%^&*()_=+`"<>.?,/\\|{}[]~\' store 123').getAttribute('value').should.eventually.equal 'store123'
    # elem.username     .clear().sendKeys('cool-store-')
    # elem.submit       .click()
    # elem.alert        .isDisplayed().should.eventually.equal true
    # elem.alert        .getText().should.eventually.equal 'Store name must begin and end with a letter or number'

    # Test for duplicate username
    # elem.email        .sendKeys '.uk'
    # elem.email_check  .sendKeys '.uk'
    # elem.username     .clear().sendKeys utils.random_user.username
    # elem.submit       .click()
    # elem.alert        .isDisplayed().should.eventually.equal true
    # elem.alert        .getText().should.eventually.equal 'username must be unique'
    # browser           .getTitle().should.eventually.equal 'Create your store | eeosk'

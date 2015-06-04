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

describe 'eeosk new.logout', () ->

  before (done) ->
    utils.reset_and_login browser
    .then (res) -> scope = res

  it 'should have a cookie before logged out', () ->
    browser.manage().getCookie 'loginToken'
    .then (token) ->
      expect(token).to.exist
      token.value.should.contain scope.token.replace(/ /, '%20')

  it 'should not persist user information into try sections after logout, especially without hard refresh', () ->
    element(has.css '[name="store-navbar"] .navbar-brand').getText().should.eventually.contain scope.user.storefront_meta.home.name
    element.all(has.repeater 'product in storefront.ee.product_selection')
    .then (products) ->
      products.length.should.equal 10
      element(has.cssContainingText '#ee-header .btn', 'More').click()
      element(has.cssContainingText '#ee-header li > a', 'Logout').click()
      element(has.cssContainingText '.btn', 'Home').click()
      element(has.cssContainingText '.btn', 'Try it out').click()
      browser.sleep 400
      element(has.repeater('theme in landing.data.demoStores').row(1)).click()
      element(has.css '[name="store-navbar"] .navbar-brand').getText().should.eventually.equal ''
      element(has.css 'ee-storefront-header .navbar-rgba-colors').getAttribute('style').should.not.eventually.contain utils.hex_to_rgb(scope.user.storefront_meta.home.topBarBackgroundColor)

  it 'should not persist storefront information into try sections after logout, especially without hard refresh', () ->
    element(has.cssContainingText '#ee-header .btn', 'Preview').click()
    element(has.css '[name="store-navbar"] .navbar-brand').getText().should.eventually.equal ''
    element(has.css '#ee-bottom-view').getText().should.eventually.contain "Add Products"
    element.all(has.repeater 'product in storefront.ee.product_selection')
    .then (products) ->
      products.length.should.equal 0

  it 'should have removed cookie', () ->
    browser.manage().getCookie 'loginToken'
    .then (token) ->
      expect(token).to.not.exist

  it 'should have proper messaging', () ->
    browser.get '/logout'
    browser.getTitle().should.eventually.contain 'Logged out'
    element(has.css('.well')).getText()
    .then (text) ->
      text.should.contain 'Logged out'
      text.should.contain 'You have been logged out successfully'

  it 'should show terms modal via footer', () ->
    element(has.cssContainingText '#ee-footer a', 'Terms & Conditions').click()
    browser.sleep 400
    element(has.css '.modal').getText().should.eventually.contain 'Seller Terms & Conditions'
    element(has.cssContainingText '.modal .btn', 'close').click()
    browser.sleep 200

  it 'should show privacy modal via footer', () ->
    element(has.cssContainingText '#ee-footer a', 'Privacy Policy').click()
    browser.sleep 400
    element(has.css '.modal').getText().should.eventually.contain 'PRIVACY STATEMENT'
    element(has.cssContainingText '.modal .btn', 'close').click()
    browser.sleep 200

  it 'should navigate to the home page via home button', () ->
    element(has.cssContainingText '.well .btn', 'Home').click()
    browser.getTitle().should.eventually.contain 'Online store builder'
    browser.navigate().back()

  it 'should navigate to the login page via login button', () ->
    element(has.cssContainingText '.well .btn', 'Login').click()
    browser.getTitle().should.eventually.contain 'Login'
    browser.navigate().back()

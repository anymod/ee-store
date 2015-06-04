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

describe 'eeosk new.try.storefront', () ->

  before () -> utils.reset browser

  it 'should have proper messaging', () ->
    browser.get '/try/storefront'
    browser.getTitle().should.eventually.contain 'My store'
    element(has.css('#ee-bottom-view')).getText()
    .then (text) ->
      text.should.contain 'This is your storefront'
      text.should.contain 'You\'ve chosen a theme, now try adding products and editing the look of your store'
      text.should.contain 'When you\'re ready to continue, you can sign up & save your progress'

  it 'should have default theme on reload', () ->
    theme =
      topBarColor: 'rgb(2, 23, 9)'
      topBarBackgroundColor: 'rgb(219, 214, 255)'
      mainImageSrc: 'v1425250403/desk1.jpg'
    element(has.css '[name="store-navbar"] ul:first-child > li:first-child a').getAttribute('style').should.eventually.contain theme.topBarColor
    element(has.css 'ee-storefront-header .navbar-rgba-colors').getAttribute('style').should.eventually.contain theme.topBarBackgroundColor
    element(has.css '.carousel > img').getAttribute('src').should.eventually.contain theme.mainImageSrc

  describe 'by clicking a top navbar button', () ->

    it 'should open the products modal', () ->
      element(has.cssContainingText '#ee-header .btn', 'Add products').click()
      browser.sleep 400
      element(has.css '.modal .modal-header').getText().should.eventually.contain 'Search'
      element(has.css '.modal .modal-header .pull-right.btn').click()
      browser.sleep 400

    it 'should navigate to the Edit state', () ->
      element(has.cssContainingText '#ee-header .btn', 'Edit').click()
      browser.getTitle().should.eventually.contain 'Try it out'
      browser.navigate().back()

    it 'should open the signup modal', () ->
      element(has.cssContainingText '#ee-header .btn', 'Sign up').click()
      browser.sleep 400
      element(has.css '.modal .modal-header').getText().should.eventually.contain 'Save & continue'
      element(has.cssContainingText '.btn', 'cancel').click()
      browser.sleep 400

    it 'should open the feedback modal', () ->
      element(has.cssContainingText '#ee-header .btn', 'Feedback').click()
      browser.sleep 400
      element(has.css '.modal .modal-header').getText().should.eventually.contain 'Submit feedback'
      element(has.cssContainingText '.btn', 'close').click()
      browser.sleep 400

    it 'should open the login modal', () ->
      element(has.cssContainingText '#ee-header .btn', 'Login').click()
      browser.sleep 400
      element(has.css '.modal .modal-header').getText().should.eventually.contain 'Login'
      element(has.cssContainingText '.btn', 'cancel').click()
      browser.sleep 400

  describe 'by clicking an informational button', () ->

    it 'should open the products modal', () ->
      element(has.cssContainingText '#ee-bottom-view .btn', 'Add products').click()
      browser.sleep 400
      element(has.css '.modal .modal-header').getText().should.eventually.contain 'Search'
      element(has.css '.modal .modal-header .pull-right.btn').click()
      browser.sleep 400

    it 'should navigate to the Edit state', () ->
      element(has.cssContainingText '#ee-bottom-view .btn', 'Edit').click()
      browser.getTitle().should.eventually.contain 'Try it out'
      browser.navigate().back()

    it 'should open the signup modal', () ->
      element(has.cssContainingText '#ee-bottom-view .btn', 'Sign up').click()
      browser.sleep 400
      element(has.css '.modal .modal-header').getText().should.eventually.contain 'Save & continue'
      element(has.cssContainingText '.btn', 'cancel').click()
      browser.sleep 400

  describe 'upon adding a product', () ->

    it 'should no longer have the informational panel', () ->
      element(has.cssContainingText '#ee-header .btn', 'Add products').click()
      browser.sleep 400
      element(has.css '.modal .modal-header').getText().should.eventually.contain 'Search'
      element(has.repeater('product in catalog.data.products').row(0)).click()
      browser.sleep 300
      element(has.cssContainingText '.btn', 'Add to store').click()
      element(has.css '.modal .modal-header .pull-right.btn').click()
      browser.sleep 400
      expect(element(has.css('#ee-bottom-view')).getText()).to.eventually.be.null


    xit 'should have the product that was added', () ->

  describe 'upon editing the theme', () ->

    xit 'should change the theme', () ->

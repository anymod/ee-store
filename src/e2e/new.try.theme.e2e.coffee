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

describe 'eeosk new.try.theme', () ->

  before (done) -> utils.reset browser

  it 'should navigate to theme choice page ', () ->
    browser.get '/try/choose-theme'
    browser.getTitle().should.eventually.contain 'Choose a theme'
    browser.sleep 400

  it 'should have the right messaging and appropriate choices', () ->
    element(has.css '#ee-bottom-view').getText().should.eventually.contain 'Choose a theme'
    element(has.css '#ee-bottom-view').getText().should.eventually.contain 'Water and Sailboat'
    element.all(has.repeater 'theme in landing.data.demoStores')
    .then (stores) ->
      stores.length.should.equal 20

  it 'should populate the try store with image and color when clicked', () ->
    store = element(has.repeater('theme in landing.data.demoStores').row(15))
    store.element(has.css 'div.pad-5').getAttribute('style')
    .then (res) ->
      scope.color           = res.split('; ')[0]
      scope.backgroundColor = res.split('; ')[1]
      store.element(has.css 'img').getAttribute('src')
    .then (res) ->
      scope.src = res.split('w_400')[1]
      store.click()
      browser.sleep 400
      browser.getTitle().should.eventually.contain 'My store'
      element(has.css '[name="store-navbar"] ul:first-child > li:first-child a').getAttribute('style').should.eventually.contain scope.color
      element(has.css 'ee-storefront-header .navbar-rgba-colors').getAttribute('style').should.eventually.contain scope.backgroundColor
      element(has.css '.carousel > img').getAttribute('src').should.eventually.contain scope.src

  it 'should populate the try models with image and color when clicked', () ->
    element(has.cssContainingText '#ee-header .btn', 'Edit').click()
    browser.getTitle().should.eventually.contain 'Try it out'
    element(has.model 'edit.ee.meta.home.topBarColor').getAttribute('value')
    .then (value) ->
      scope.color.should.contain utils.hex_to_rgb(value)
      element(has.model 'edit.ee.meta.home.topBarBackgroundColor').getAttribute('value')
    .then (value) ->
      scope.backgroundColor.should.contain utils.hex_to_rgb(value)
      element(has.css '#ee-middle-view [dropdown-toggle] > img').getAttribute('ng-src')
    .then (value) ->
      value.should.contain scope.src

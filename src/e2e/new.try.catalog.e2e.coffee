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

describe 'eeosk new.try.catalog', () ->

  before (done) ->
    utils.reset browser
    .then (res) ->
      scope = res
      scope.categories = ['All'].concat _.unique(_.pluck scope.products, 'category')
    .then () -> utils.create_products([21..150])

  it 'should have proper messaging', () ->
    browser.get '/try/products'
    browser.getTitle().should.eventually.contain 'Add products'

  it 'should show 48 products per page', () ->
    element.all(has.repeater 'product in catalog.data.products')
    .then (products) ->
      scope.initialProducts = products
      products.length.should.equal 48

  it 'should show popover', () ->
    element(has.css '#ee-top-view').getText().should.eventually.contain 'Looking good!'
    element(has.css '#ee-top-view').getText().should.eventually.contain 'Add products below and they\'ll appear in your store'

  it 'should be able to close popover', () ->
    element(has.cssContainingText '#ee-top-view .btn', 'close').click()
    element(has.css '#ee-top-view').getText().should.not.eventually.contain 'Looking good!'
    element(has.css '#ee-top-view').getText().should.not.eventually.contain 'Add products below and they\'ll appear in your store'

  it 'should have pagination', () ->
    element(has.css '.navbar-subheader [name="right-btn"]').click()
    element.all(has.repeater 'product in catalog.data.products')
    .then (products) ->
      products.length.should.equal 48
      testProductExclusion = (product) -> scope.initialProducts.indexOf(product).should.equal -1
      testProductExclusion product for product in products
      element(has.css '.navbar-subheader [name="left-btn"]').click()
      element.all(has.repeater 'product in catalog.data.products')
    .then (products) ->
      products.length.should.equal 48
      testProductInclusion = (product) -> scope.initialProducts.indexOf(product).should.not.equal -1
      # testProductInclusion product for product in products

  xit 'should sort products based on category', () ->
  xit 'should sort products based on price', () ->
  xit 'should sort products based on search', () ->
  xit 'should add products to store', () ->
  xit 'should show link to preview store after adding', () ->
  xit 'should show badge for products in the store', () ->
  xit 'should be able to change price', () ->
  xit 'should remove products from store', () ->
  xit 'should persist product selections upon signup', () ->

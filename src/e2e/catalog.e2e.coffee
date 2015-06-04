process.env.NODE_ENV = 'test'
utils           = require './utils.e2e.db'
chai            = require 'chai'
expect          = require('chai').expect
should          = chai.should()
chaiAsPromised  = require 'chai-as-promised'
chai.use chaiAsPromised
_               = require 'lodash'

elem    = {}
newVal  = {}
scope   = {}

describe 'eeosk catalog', () ->

  before (done) ->
    elem =
      storefrontBtn:            element byAttr.name 'storefront-btn'
      catalogBtn:               element byAttr.name 'catalog-btn'
      offscreen:                element byAttr.css '#ee-offscreen'
      alert:                    element byAttr.css '.alert'
      search:                   element byAttr.model 'search'
      products:                 element.all byAttr.repeater('product in products')
      productSix:               element byAttr.repeater('product in products').row(5)
      productFocus:             element byAttr.css '#ee-offscreen [name="product-focus"]'
      margin25:                 element byAttr.repeater('margin in margin_array').row(4)
      addBtn:                   element byAttr.cssContainingText('#ee-offscreen .btn-primary', 'Add to store')
      seeInStoreBtn:            element byAttr.cssContainingText('#ee-offscreen .btn-primary', 'See in store')
      removeBtn:                element byAttr.cssContainingText('#ee-offscreen .btn-danger', 'Remove from my store')
      leftBtn:                  element byAttr.name 'left-btn'
      rightBtn:                 element byAttr.name 'right-btn'
      storeProducts:            element.all byAttr.repeater('product in storefront.product_selection')

    utils.reset_and_login(browser)
    .then (res) ->
      scope = res
      scope.categories = ['All'].concat _.unique(_.pluck scope.products, 'category')
    .then () -> utils.create_products([21..150])

  it 'should have 48 selectable products per page', () ->
    browser.get '/catalog'
    browser                     .getTitle().should.eventually.equal 'Add products | eeosk'
    elem.rightBtn               .click()
    elem.rightBtn               .click()
    elem.rightBtn               .click()
    elem.products
    .then (product_array) ->
      product_array             .length.should.equal 48
      elem.productSix           .getText().should.not.eventually.contain 'in my store'

  it 'should show product in offscreen when clicked', () ->
    elem.productSix             .click()
    elem.productFocus           .getAttribute('e2e-id')
    .then (attr) ->
      utils                     .product_by_id parseInt(attr)
    .then (product) ->
      scope.product     =       product[0]
      elem.productFocus         .getText()
    .then (text) ->
      # Focused product should have proper info
      base_cents        =       parseInt(scope.product.baseline_price)
      price_cents       =       parseInt(scope.product.baseline_price / (1 - 0.15))
      sell_cents        =       price_cents - base_cents
      baseline          =       (base_cents/100).toFixed(2)
      selling_15        =       (price_cents/100).toFixed(2)
      margin_15         =       (sell_cents/100).toFixed(2)
      text                      .should.contain 'Add to store'
      text                      .should.contain '$'  + selling_15
      text                      .should.contain '+$' + parseInt(495)/100 + ' s/h'
      text                      .should.contain '15% margin: you earn $' + margin_15 + ' per sale'
      text                      .should.contain scope.product.title
      text                      .should.contain scope.product.content

  it 'should update info after margin is changed', () ->
    elem.margin25               .click()
    elem.productFocus           .getText()
    .then (text) ->
      base_cents        =       parseInt(scope.product.baseline_price)
      price_cents       =       parseInt(scope.product.baseline_price / (1 - 0.25))
      sell_cents        =       price_cents - base_cents
      baseline          =       (base_cents/100).toFixed(2)
      selling_25        =       (price_cents/100).toFixed(2)
      margin_25         =       (sell_cents/100).toFixed(2)
      text                      .should.contain 'Add to store'
      text                      .should.contain '$'  + selling_25
      text                      .should.contain '+$' + parseInt(495)/100 + ' s/h'
      text                      .should.contain '25% margin: you earn $' + margin_25 + ' per sale'
      text                      .should.contain scope.product.title
      text                      .should.contain scope.product.content
      scope.selling_25  =       selling_25

  it 'should have functional add and remove buttons', () ->
    elem.addBtn               .click()
    elem.productFocus         .getText()
    .then (text) ->
      text                      .should.contain 'See in store'
      text                      .should.contain 'Remove from my store'
      elem.productSix           .getText().should.eventually.contain 'in my store'
      elem.removeBtn            .click()
      elem.productSix           .getText().should.not.eventually.contain 'in my store'
      elem.addBtn               .click()

  it 'should show appropriate info if already in store', () ->
    elem.productSix             .click()
    elem.productFocus           .getText()
    .then (text) ->
      base_cents        =       parseInt(scope.product.baseline_price)
      price_cents       =       parseInt(scope.product.baseline_price / (1 - 0.25))
      sell_cents        =       price_cents - base_cents
      baseline          =       (base_cents/100).toFixed(2)
      selling_25        =       (price_cents/100).toFixed(2)
      margin_25         =       (sell_cents/100).toFixed(2)
      text                      .should.contain 'See in store'
      text                      .should.contain '$'  + selling_25
      text                      .should.contain '+$' + parseInt(495)/100 + ' s/h'
      text                      .should.contain '25% margin: you earn $' + margin_25 + ' per sale'
      text                      .should.contain scope.product.title
      text                      .should.contain scope.product.content

  it 'should have functional "See in store" button', () ->
    elem.seeInStoreBtn        .click()
    elem.storeProducts        .getText()
    .then (text) ->
      allText = text.join(' | ')
      allText                   .should.contain scope.product.title
      allText                   .should.contain scope.selling_25
      allText                   .should.not.contain scope.product.content

  # TODO continue implementing catalog tests
  xit 'should filter by category', () ->
    elem.catalogBtn           .click()


  xit 'should filter by price range', () ->
  xit 'should filter by search', () ->

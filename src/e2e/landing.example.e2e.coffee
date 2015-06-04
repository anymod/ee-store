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

describe 'eeosk landing.example', () ->

  before (done) ->

    elem =
      navbarBrand:        element byAttr.cssContainingText 'a', 'Demo'
      exampleBtn:         element byAttr.cssContainingText '.btn', 'See a demo store'
      backBtn:            element byAttr.cssContainingText '.btn', 'Back'
      categories:         element.all byAttr.repeater 'category in categories'
      categoryThree:      element byAttr.repeater('category in categories').row(2)
      products:           element.all byAttr.repeater 'product in storefront.product_selection'
      productFive:        element byAttr.repeater('product in storefront.product_selection').row(4)
      exampleOverlay:     element byAttr.css '.position-absolute.top-left-bottom-right-0.hover-pointer.text-center'
      noThanksBtn:        element byAttr.cssContainingText '.btn', 'No thanks'
      tryBtn:             element byAttr.cssContainingText '.btn', 'Try building yours'

  it 'should show the example store', () ->
    browser.get '/'
    elem.exampleBtn       .click()
    browser               .getTitle().should.eventually.contain 'Demo Store'
    elem.navbarBrand      .getText().should.eventually.contain 'Demo Store'
    elem.categories
    .then (category_array) ->
      category_array      .length.should.equal 6
      elem.categoryThree  .getText().should.eventually.contain 'Jewelry'
      elem.products
    .then (product_array) ->
      product_array       .length.should.equal 8
      elem.productFive    .getText().should.eventually.contain 'Slitzer™ 16pc Cutlery Set in Wood Block\n$42.68'

  it 'should go back to the landing page when back button is clicked', () ->
    elem.backBtn          .click()
    browser               .getTitle().should.eventually.contain 'Online store builder'

  it 'should show modal when anything is clicked', () ->
    browser.get '/'
    elem.exampleBtn       .click()
    browser               .getTitle().should.eventually.contain 'Demo Store'
    elem.exampleOverlay   .click()
    elem.noThanksBtn      .click()
    browser               .getTitle().should.eventually.contain 'Demo Store'
    elem.exampleOverlay   .click()
    elem.tryBtn           .click()
    browser               .getTitle().should.eventually.contain 'Try it out'

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

describe 'eeosk new.landing', () ->

  before () -> utils.reset browser

  it 'should show the landing page', () ->
    browser.get '/'
    browser.getTitle().should.eventually.contain 'Online store builder, ecommerce storefront, dropship product catalog'
    element(has.css '.jumbotron').getText()
    .then (text) ->
      text.should.contain 'Create an online store in minutes'
      text.should.contain 'Choose inventory from a catalog of products and let eeosk manage overhead and shipping.'

  it 'should navigate to login with either button', () ->
    element(has.cssContainingText '#navbar-top .btn', 'Login').click()
    browser.getTitle().should.eventually.contain 'Login'
    element(has.css '#navbar-top a > img').click()
    browser.getTitle().should.eventually.contain 'Online store builder'
    element(has.cssContainingText '#ee-footer .btn', 'Login').click()
    browser.getTitle().should.eventually.contain 'Login'
    element(has.css '#navbar-top a > img').click()

  it 'should navigate to example page ', () ->
    element(has.cssContainingText '.jumbotron .btn', 'See a demo store').click()
    browser.sleep 400
    browser.getTitle().should.eventually.contain 'Demo Store'
    browser.navigate().back()
    browser.sleep 400
    browser.getTitle().should.eventually.contain 'Online store builder'

  it 'should navigate to theme choice page ', () ->
    element(has.cssContainingText '.jumbotron .btn', 'Try it out').click()
    browser.sleep 400
    browser.getTitle().should.eventually.contain 'Choose a theme'
    browser.navigate().back()
    browser.sleep 400
    browser.getTitle().should.eventually.contain 'Online store builder'

  it 'should show terms modal', () ->
    browser.sleep 400
    element(has.cssContainingText '#ee-footer a', 'Terms & Conditions').click()
    browser.sleep 400
    element(has.css '.modal').getText().should.eventually.contain 'Seller Terms & Conditions'
    element(has.cssContainingText '.modal .btn', 'close').click()
    browser.sleep 200

  it 'should show privacy modal', () ->
    browser.sleep 400
    element(has.cssContainingText '#ee-footer a', 'Privacy Policy').click()
    browser.sleep 400
    element(has.css '.modal').getText().should.eventually.contain 'PRIVACY STATEMENT'
    element(has.cssContainingText '.modal .btn', 'close').click()
    browser.sleep 200

  it 'should show faq modal', () ->
    browser.sleep 400
    element(has.cssContainingText '#ee-footer a', 'FAQ').click()
    browser.sleep 400
    element(has.css '.modal').getText().should.eventually.contain 'Frequently Asked Questions'
    element(has.cssContainingText '.modal .btn', 'close').click()
    browser.sleep 200

  xit 'should navigate to about page', () ->
  xit 'should navigate to faq page ', () ->

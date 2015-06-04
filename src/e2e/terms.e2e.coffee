process.env.NODE_ENV = 'test'
utils           = require './utils.e2e.db'
chai            = require 'chai'
expect          = require('chai').expect
should          = chai.should()
chaiAsPromised  = require 'chai-as-promised'
chai.use chaiAsPromised

describe 'eeosk terms', () ->

  it 'should display T&C when clicked on signup page', () ->
    browser.get '/create-online-store'
    element(byAttr.css('.well')).getText().should.eventually.not.contain "Agreement between user and https://eeosk.com"
    element(byAttr.name('termsLink')).click()
    element(byAttr.css('.well')).getText().should.eventually.contain "Agreement between user and https://eeosk.com"

  it 'should navigate and display terms page', () ->
    browser.get '/terms'
    browser.getTitle().should.eventually.have.string 'Terms & Conditions'
    element(byAttr.css('.well')).getText().should.eventually.have.string 'Seller Terms & Conditions'

  it 'should navigate and display privacy page', () ->
    browser.get '/privacy'
    browser.getTitle().should.eventually.have.string 'Privacy Policy'
    element(byAttr.css('.well')).getText().should.eventually.have.string 'WHAT DO WE DO WITH YOUR INFORMATION?'

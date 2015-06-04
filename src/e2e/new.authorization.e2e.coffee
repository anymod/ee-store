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

describe 'eeosk new.authorization', () ->

  before () ->
    utils.reset(browser)
    .then (scp) -> scope.token = scp.token

  describe 'permissions', () ->

    it 'should not allow app visits when logged out', () ->
      browser.get '/storefront'
      browser.getCurrentUrl().should.eventually.equal 'http://localhost:3333/login'
      browser.get '/edit'
      browser.getCurrentUrl().should.eventually.equal 'http://localhost:3333/login'
      browser.get '/products'
      browser.getCurrentUrl().should.eventually.equal 'http://localhost:3333/login'
      browser.get '/orders'
      browser.getCurrentUrl().should.eventually.equal 'http://localhost:3333/login'
      browser.get '/account'
      browser.getCurrentUrl().should.eventually.equal 'http://localhost:3333/login'

  describe 'redirects', () ->

    it 'should redirect from try- states when logged in', () ->
      utils.log_in scope.token
      .then () ->
        browser.sleep 400
        browser.get '/try/storefront'
        browser.getCurrentUrl().should.eventually.equal 'http://localhost:3333/storefront'
        browser.get '/try/edit'
        browser.getCurrentUrl().should.eventually.equal 'http://localhost:3333/edit'
        browser.get '/try/products'
        browser.getCurrentUrl().should.eventually.equal 'http://localhost:3333/products'

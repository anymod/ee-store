process.env.NODE_ENV = 'test'
utils           = require './utils.e2e.db'
chai            = require 'chai'
expect          = require('chai').expect
should          = chai.should()
chaiAsPromised  = require 'chai-as-promised'
chai.use chaiAsPromised

describe 'eeosk new.general', () ->

  it 'should redirect to home when path not found', () ->
    browser.manage().deleteAllCookies()
    browser.get '/foobar'
    browser.getTitle().should.eventually.have.string 'Online store builder'
    browser.getCurrentUrl().should.eventually.equal browser.baseUrl + '/'

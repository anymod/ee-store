process.env.NODE_ENV = 'test'
utils           = require './utils.e2e.db'
chai            = require 'chai'
expect          = require('chai').expect
should          = chai.should()
chaiAsPromised  = require 'chai-as-promised'
chai.use chaiAsPromised
_               = require 'lodash'

elem    = {}
oldVal  = {}
newVal  = {}
scope   = {}

describe 'eeosk new.tour', () ->

  before (done) ->
    utils.reset browser
    scope.test_signup_error = () ->
      element(has.model 'is.email').clear().sendKeys('foo@bar')
      element(has.css 'form [type="submit"]').click()
      element(has.css 'form').getText().should.eventually.contain 'That doesn\'t look like a valid email address.'
    scope.test_signup = () ->
      element(has.model 'is.email').clear().sendKeys('foo@bar.baz')
      element(has.css 'form [type="submit"]').click()
      browser.getTitle().should.eventually.contain 'You\'re signed up'
      browser.navigate().back()

  it 'should navigate from the landing page', () ->
    browser.get '/'
    element(has.cssContainingText 'a', 'Take the Tour').click()

  describe 'your-own-business', () ->

    it 'should have proper messaging', () ->
      browser.getTitle().should.eventually.contain 'your own business'
      element(has.css '.is-well').getText().should.eventually.contain 'your own business'

    it 'should navigate left', () ->
      element(has.css '.is-arrow-left').click()
      browser.getTitle().should.eventually.contain 'everything you need'
      browser.navigate().back()

    it 'should navigate right', () ->
      element(has.css '.is-arrow-right').click()
      browser.getTitle().should.eventually.contain 'easy to use'
      browser.navigate().back()

    it 'should have functional signup', () ->
      scope.test_signup_error()
      scope.test_signup()

    it 'should navigate right from the bottom', () ->
      element(has.css '.height-450.hover-frost').click()
      browser.getTitle().should.eventually.contain 'easy to use'

  describe 'easy-to-use', () ->

    it 'should have proper messaging', () ->
      browser.getTitle().should.eventually.contain 'easy to use'
      element(has.css '.is-well').getText().should.eventually.contain 'easy to use'

    it 'should navigate left', () ->
      element(has.css '.is-arrow-left').click()
      browser.getTitle().should.eventually.contain 'your own business'
      browser.navigate().back()

    it 'should navigate right', () ->
      element(has.css '.is-arrow-right').click()
      browser.getTitle().should.eventually.contain 'beautiful and customizable'
      browser.navigate().back()

    it 'should have functional signup', () ->
      scope.test_signup_error()
      scope.test_signup()

    it 'should navigate right from the bottom', () ->
      element(has.css '.height-450.hover-frost').click()
      browser.getTitle().should.eventually.contain 'beautiful and customizable'

  describe 'beautiful-and-customizable', () ->

    it 'should have proper messaging', () ->
      browser.getTitle().should.eventually.contain 'beautiful and customizable'
      element(has.css '.is-well').getText().should.eventually.contain 'beautiful & customizable'

    it 'should navigate left', () ->
      element(has.css '.is-arrow-left').click()
      browser.getTitle().should.eventually.contain 'easy to use'
      browser.navigate().back()

    it 'should navigate right', () ->
      element(has.css '.is-arrow-right').click()
      browser.getTitle().should.eventually.contain 'everything you need'
      browser.navigate().back()

    it 'should have functional signup', () ->
      scope.test_signup_error()
      scope.test_signup()

    it 'should navigate right from the bottom', () ->
      element(has.css '.height-450.hover-frost').click()
      browser.getTitle().should.eventually.contain 'everything you need'

  describe 'everything you need', () ->

    it 'should have proper messaging', () ->
      browser.getTitle().should.eventually.contain 'everything you need'
      element(has.css '.is-well').getText().should.eventually.contain 'everything you need'

    it 'should navigate left', () ->
      element(has.css '.is-arrow-left').click()
      browser.getTitle().should.eventually.contain 'beautiful and customizable'
      browser.navigate().back()

    it 'should navigate right', () ->
      element(has.css '.is-arrow-right').click()
      browser.getTitle().should.eventually.contain 'your own business'
      browser.navigate().back()

    it 'should have functional signup', () ->
      scope.test_signup_error()
      scope.test_signup()

    it 'should restart the tour from the bottom', () ->
      element(has.cssContainingText 'h3', 'See the tour again').click()
      browser.getTitle().should.eventually.contain 'your own business'

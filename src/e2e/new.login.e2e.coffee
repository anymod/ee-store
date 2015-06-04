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

describe 'eeosk new.login', () ->

  before () -> utils.reset browser

  describe 'dedicated signin page', () ->

    it 'should be able to sign in from the landing page', () ->
      browser.get '/'
      element(has.cssContainingText '#navbar-top .btn', 'Sign in').click()
      browser.getTitle().should.eventually.contain 'Sign in'
      element(has.css '.well').getText().should.eventually.contain 'Sign in'
      element(has.css '.alert').isDisplayed().should.eventually.equal false
      element(has.model 'login.email').sendKeys utils.test_user.email
      element(has.model 'login.password').sendKeys utils.test_user.password
      element(has.cssContainingText '.well .btn', 'Sign in').click()
      browser.getTitle().should.eventually.contain 'My store'
      browser.get '/logout'

    it 'should navigate to the reset password state', () ->
      element(has.cssContainingText '#navbar-top .btn', 'Sign in').click()
      browser.getTitle().should.eventually.contain 'Sign in'
      element(has.cssContainingText 'a', 'Reset password').click()
      browser.getTitle().should.eventually.contain 'Reset your password'
      browser.navigate().back()

    it 'should navigate to the landing state', () ->
      element(has.css '#brand').click()
      browser.getTitle().should.eventually.contain 'Online store builder'
      browser.navigate().back()

    it 'should show message on invalid password', () ->
      element(has.css '.alert').isDisplayed().should.eventually.equal false
      element(has.model 'login.email').sendKeys utils.test_user.email
      element(has.model 'login.password').sendKeys 'foobar'
      element(has.cssContainingText '.well .btn', 'Sign in').click()
      element(has.css '.alert').getText().should.eventually.equal 'Invalid email or password'

    it 'should show message on invalid email', () ->
      browser.navigate().back()
      browser.navigate().forward()
      element(has.css '.alert').isDisplayed().should.eventually.equal false
      element(has.model 'login.email').sendKeys('another-' + utils.test_user.email)
      element(has.model 'login.password').sendKeys utils.test_user.password
      element(has.cssContainingText '.well .btn', 'Sign in').click()
      element(has.css '.alert').getText().should.eventually.equal 'Invalid email or password'

  xdescribe 'login modal', () ->

    it 'should be able to log in via modal from the try sections', () ->
      browser.get '/try/edit'
      browser.getTitle().should.eventually.contain 'Try it out'
      element(has.cssContainingText '#ee-header .btn', 'Login').click()
      browser.sleep 300
      element(has.css '.modal').getText().should.eventually.contain 'Login'
      element(has.model 'modal.email').sendKeys utils.test_user.email
      element(has.model 'modal.password').sendKeys utils.test_user.password
      element(has.cssContainingText '.btn', 'Sign in').click()
      browser.getTitle().should.eventually.contain 'My store'
      browser.get '/logout'

    it 'should open and close the modal', () ->
      browser.get '/try/edit'
      browser.getTitle().should.eventually.contain 'Try it out'
      element(has.cssContainingText '#ee-header .btn', 'Login').click()
      browser.sleep 300
      element(has.cssContainingText '.modal .btn', 'cancel').click()
      browser.sleep 300
      element(has.css '.modal').isPresent().should.eventually.equal false

    it 'should open sign up modal', () ->
      element(has.cssContainingText '#ee-header .btn', 'Login').click()
      browser.sleep 300
      element(has.cssContainingText '.modal a', 'Sign up').click()
      browser.sleep 100
      element(has.css '.modal').getText().should.eventually.contain 'Save & continue'
      element(has.cssContainingText '.modal .btn', 'cancel').click()
      browser.sleep 300

    it 'should navigate to reset password state', () ->
      element(has.cssContainingText '#ee-header .btn', 'Login').click()
      browser.sleep 300
      element(has.cssContainingText '.modal a', 'Forgot password').click()
      browser.getTitle().should.eventually.contain 'Reset your password'
      browser.navigate().back()

    it 'should show message on invalid password', () ->
      element(has.cssContainingText '#ee-header .btn', 'Login').click()
      browser.sleep 300
      element(has.css '.alert').isDisplayed().should.eventually.equal false
      element(has.model 'modal.email').sendKeys utils.test_user.email
      element(has.model 'modal.password').sendKeys 'foobar'
      element(has.cssContainingText '.btn', 'Sign in').click()
      element(has.css '.alert').getText().should.eventually.equal 'Invalid email or password'
      element(has.cssContainingText '.modal .btn', 'cancel').click()
      browser.sleep 300

    it 'should show message on invalid email', () ->
      element(has.cssContainingText '#ee-header .btn', 'Login').click()
      browser.sleep 300
      element(has.css '.alert').isDisplayed().should.eventually.equal false
      element(has.model 'modal.email').sendKeys('another-' + utils.test_user.email)
      element(has.model 'modal.password').sendKeys utils.test_user.password
      element(has.cssContainingText '.btn', 'Sign in').click()
      element(has.css '.alert').getText().should.eventually.equal 'Invalid email or password'

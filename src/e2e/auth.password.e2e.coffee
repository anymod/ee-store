process.env.NODE_ENV = 'test'
utils           = require './utils.e2e.db'
chai            = require 'chai'
expect          = require('chai').expect
should          = chai.should()
chaiAsPromised  = require 'chai-as-promised'
chai.use chaiAsPromised

entry = {}
elem  = {}
scope = {}

describe 'eeosk auth.password', () ->

  before (done) ->
    elem =
      alert:                  element byAttr.css '.alert'
      email:                  element byAttr.model 'email'
      password:               element byAttr.model 'password'
      password_confirmation:  element byAttr.model 'password_confirmation'
      submit_email:           element byAttr.css 'button[name="submitEmail"]'
      submit_password:        element byAttr.css 'button[name="submitPassword"]'
      login:                  element byAttr.css 'a[name="loginBtn"]'
    utils.delete_all_tables()
    .then () -> utils.create_user(utils.random_user)
    .then (body) -> scope.username = body.user.username

  it 'should send reset email with a link that works once', () ->
    browser.get '/reset-password'
    elem.alert            .isDisplayed().should.eventually.equal false
    elem.email            .sendKeys 'nonexistent@example.com'
    elem.submit_email     .click()
    elem.alert            .isDisplayed().should.eventually.equal true
    elem.alert            .getText().should.eventually.equal 'User not found'
    elem.email            .clear().sendKeys utils.random_user.email
    elem.submit_email     .click()
    elem.alert            .isDisplayed().should.eventually.equal true
    elem.alert.getText()
    .then (text) ->
      text.should.equal 'Please check your email for a link to reset your password.'
      utils.user_by_username scope.username
    .then (user) ->
      password_reset_token = user[0].restricted_meta.password_reset_token
      expect(password_reset_token).to.exist
      # generate a jwt similar to one sent in the email
      token = utils.jwt({ token: user[0].ee_uuid, password_reset_token: password_reset_token })
      browser.get '/reset-password?token=' + token
      elem.alert                  .isDisplayed().should.eventually.equal false
      elem.password               .clear().sendKeys 'foobar'
      elem.password_confirmation  .clear().sendKeys 'foobar'
      elem.submit_password        .click()
      elem.alert                  .getText().should.eventually.equal 'Password must be at least 8 characters'
      elem.password               .clear().sendKeys 'foobarbaz'
      elem.password_confirmation  .clear().sendKeys 'foobarbaz'
      elem.submit_password        .click()
      elem.alert                  .getText().should.eventually.equal 'Password reset successfully. Log in to continue.'
      elem.login                  .click()
      browser                     .getTitle().should.eventually.equal 'Login | eeosk'
      # Token should fail on second use
      browser.get '/reset-password?token=' + token
      elem.password               .clear().sendKeys 'bazfoobar99'
      elem.password_confirmation  .clear().sendKeys 'bazfoobar99'
      elem.submit_password        .click()
      elem.alert                  .getText().should.eventually.equal 'Invalid password reset token'

'use strict'

angular.module('builder.auth').controller 'loginCtrl', ($state, eeAuth, eeModal) ->
  this.alert    = ''
  that          = this
  if $state.params.exists then this.alert = 'Your account is active. Please sign in.'

  setBtnText    = (txt) -> that.btnText = txt
  resetBtnText  = ()    -> setBtnText 'Sign in'
  resetBtnText()

  this.login = () ->
    that.alert = ''
    setBtnText 'Sending...'
    eeAuth.fns.setUserFromCredentials that.email, that.password
    .then () ->
      eeModal.fns.closeLoginModal()
      $state.go 'storefront'
    .catch (err) ->
      resetBtnText()
      alert = err.message || err || 'Problem logging in'
      if typeof alert is 'object' then alert = 'Problem logging in'
      that.alert = alert

  this.signup = () -> eeModal.fns.open 'signup'

  return

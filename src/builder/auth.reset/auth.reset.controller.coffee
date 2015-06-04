'use strict'

angular.module('builder.auth').controller 'resetCtrl', ($location, eeAuth) ->

  this.alert = ''
  this.show =
    email:    true
    password: false
    login:    false

  that = this

  setBtnText    = (txt) -> that.btnText = txt
  resetBtnText  = ()    -> setBtnText 'Submit'
  resetBtnText()

  this.sendPasswordResetEmail = () ->
    setBtnText 'Sending...'
    eeAuth.fns.sendPasswordResetEmail that.email
    .then (data) ->
      that.alert = 'Please check your email for a link to reset your password.'
      that.show.email     = false
      that.show.password  = false
      that.show.login     = false
    .catch (err) ->
      resetBtnText()
      that.alert = err?.message || 'Problem sending'
    return

  if $location.search().token
    that.show.email     = false
    that.show.password  = true
    that.show.login     = false
    that.resetPassword  = () ->
      setBtnText 'Sending...'
      if that.password isnt that.password_confirmation
        that.alert = 'Passwords must match'
        resetBtnText()
        return
      eeAuth.fns.resetPassword that.password, $location.search().token
      .then (data) ->
        that.alert = 'Password reset successfully. Log in to continue.'
        that.show.email     = false
        that.show.password  = false
        that.show.login     = true
      .catch (err) ->
        resetBtnText()
        if !!err.message and err.message.indexOf('JSON') >= 0
          that.alert = 'Link is invalid or expired.  Please generate another link below.'
          that.show.email     = false
          that.show.password  = true
          that.show.login     = false
        else
          that.alert = err?.message || 'Problem sending'

  return

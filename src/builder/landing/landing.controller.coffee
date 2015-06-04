'use strict'

angular.module('builder.landing').controller 'landingCtrl', ($state, eeDefiner, eeAuth, eeModal, eeLanding, eeStorefront) ->

  that = this

  this.ee = eeDefiner.exports

  this.show     = eeLanding.show
  this.data     = eeLanding.data
  this.fns      = eeLanding.fns
  this.authFns  = eeAuth.fns
  this.authExp  = eeAuth.exports
  this.modalFns = eeModal.fns

  this.signup = () ->
    eeAuth.fns.createUserFromEmail that.email
    .then (user) -> $state.go 'go', token: user.go_token
    .catch (err) ->
      if err.message is 'Email format is invalid' then return that.error = 'That doesn\'t look like a valid email address. Please try again.'
      if err.message is 'Account exists' then return $state.transitionTo 'login', { exists: true }
      that.error = 'Problem signing up'

  eeLanding.fns.showState $state.current.name

  return

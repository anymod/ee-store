'use strict'

angular.module('builder.go').controller 'goCtrl', ($state, eeDefiner, eeAuth) ->

  that = this
  this.ee   = eeDefiner.exports
  this.auth = eeAuth.exports

  if !this.auth?.user?.email then eeAuth.fns.defineUserFromGoToken $state.params.token

  return

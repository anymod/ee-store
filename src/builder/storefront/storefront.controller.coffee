'use strict'

angular.module('builder.storefront').controller 'storefrontCtrl', ($state, eeDefiner, eeModal) ->

  this.ee = eeDefiner.exports
  this.modalFns = eeModal.fns
  this.state = $state.current.name

  return

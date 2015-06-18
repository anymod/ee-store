'use strict'

angular.module('eeStore').controller 'storeCtrl', ($rootScope, eeDefiner, eeBootstrap) ->
  that = this
  this.ee = eeDefiner.exports
  if eeBootstrap.meta
    that.ee.meta      = eeBootstrap.meta
    that.ee.carousel  = eeBootstrap.meta.home.carousel[0]

  return

'use strict'

angular.module('eeStore').controller 'storeCtrl', ($rootScope, eeDefiner, eeBootstrap) ->
  that = this
  this.ee = eeDefiner.exports
  if eeBootstrap.storefront_meta
    that.ee.meta      = eeBootstrap.storefront_meta
    that.ee.carousel  = eeBootstrap.storefront_meta.home.carousel[0]

  return

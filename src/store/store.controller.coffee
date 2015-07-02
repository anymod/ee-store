'use strict'

angular.module('eeStore').controller 'storeCtrl', (eeBootstrap) ->

  this.ee =
    meta: eeBootstrap?.storefront_meta
    carousel: eeBootstrap?.storefront_meta?.home?.carousel[0]

  this.data = eeBootstrap

  return

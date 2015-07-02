'use strict'

angular.module('eeStore').controller 'selectionCtrl', ($rootScope, eeBootstrap, eeCart) ->

  this.ee =
    meta: eeBootstrap?.storefront_meta
    carousel: eeBootstrap?.storefront_meta?.home?.carousel[0]

  this.data = eeBootstrap

  $rootScope.$on 'add:selection', (e, selection_id) ->
    eeCart.fns.addSelection selection_id, eeBootstrap.cart?.quantity_array

  return

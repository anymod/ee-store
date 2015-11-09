'use strict'

angular.module('eeStore').controller 'productCtrl', ($rootScope, eeBootstrap, eeCart) ->

  product = this

  product.ee =
    Collections:
      collections:  eeBootstrap?.collections
      nav:          eeBootstrap?.nav

  product.data =
    product: eeBootstrap.product

  $rootScope.$on 'cart:add:sku', (e, sku_id) ->
    eeCart.fns.addSku sku_id, eeBootstrap.cart?.quantity_array

  return

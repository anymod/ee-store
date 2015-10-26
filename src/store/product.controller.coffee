'use strict'

angular.module('eeStore').controller 'productCtrl', ($rootScope, eeBootstrap, eeCart) ->

  product = this

  product.ee =
    Collections:
      collections:  eeBootstrap?.collections
      nav:          eeBootstrap?.nav

  product.data =
    product: eeBootstrap.product

  $rootScope.$on 'add:product', (e, product_id) ->
    eeCart.fns.addProduct product_id, eeBootstrap.cart?.quantity_array

  return

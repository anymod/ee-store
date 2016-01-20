'use strict'

angular.module('eeStore').controller 'productCtrl', ($rootScope, $stateParams, eeBootstrap, eeDefiner, eeProduct, eeCart) ->

  product = this

  product.id = parseInt($stateParams.id)
  product.ee = eeDefiner.exports
  product.data = product.ee.Product

  if product.ee.Product?.product?.id isnt product.id then eeProduct.fns.defineProduct product.id
  
  return

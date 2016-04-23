'use strict'

angular.module('eeStore').controller 'productCtrl', ($rootScope, $stateParams, $location, eeBootstrap, eeDefiner, eeProduct, eeCart) ->

  product = this

  product.id = parseInt($stateParams.id)
  product.ee = eeDefiner.exports
  product.data = product.ee.Product
  product.currentUrl = $location.absUrl()

  if product.ee.Product?.product?.id isnt product.id then eeProduct.fns.defineProduct product.id

  return

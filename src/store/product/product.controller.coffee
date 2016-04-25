'use strict'

angular.module('eeStore').controller 'productCtrl', ($rootScope, $stateParams, $location, eeBootstrap, eeDefiner, eeProduct, eeProducts, eeCart) ->

  product = this

  product.id = parseInt($stateParams.id)
  product.ee = eeDefiner.exports
  product.data = product.ee.Product
  product.currentUrl = $location.absUrl()

  searchLike = () ->
    return unless product.data.product?.title?
    eeProducts.fns.searchLike product.data.product.title, product.data.product.category_id

  if product.ee.Product?.product?.id isnt product.id
    eeProduct.fns.defineProduct product.id
    .then () -> searchLike()
  else
    searchLike()

  return

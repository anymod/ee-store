'use strict'

angular.module('eeStore').controller 'cartCtrl', ($rootScope, $scope, $window, $location, $cookies, eeBootstrap, eeDefiner, eeSecureUrl, eeCart, eeBack) ->

  cart = this

  cart.ee = eeDefiner.exports

  ###### OLD

  eeCart.fns.defineCart()

  cart.removeSku = (sku_id) -> eeCart.fns.removeSku sku_id

  cart.buy = () ->
    if cart.ee.Cart?.skus?.length > 0
      cart.processing = true
      $window.location.assign(eeSecureUrl + 'checkout/' + $cookies.get('cart')?.split('.')[2])

  cart.update = () -> eeCart.fns.createOrUpdate()

  return

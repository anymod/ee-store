'use strict'

angular.module('eeStore').controller 'cartCtrl', ($scope, $location, eeCart) ->
  this.data             = eeCart.data
  this.cart_url         = $location.absUrl()

  that                  = this

  this.removeProduct = (product) -> eeCart.removeProduct product

  $scope.$watch 'cart.data.entries', (newVal, oldVal) ->
    eeCart.calculate()
  , true

  return

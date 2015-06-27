'use strict'

module = angular.module 'ee-storefront-header', []

module.directive "eeStorefrontHeader", ($rootScope, $state, eeStorefront, eeCart) ->
  templateUrl: 'ee-shared/components/ee-storefront-header.html'
  scope:
    meta:         '='
    blocked:      '='
    loading:      '='
    collections:  '='
  link: (scope, ele, attrs) ->
    scope.isStore     = $rootScope.isStore
    scope.isBuilder   = $rootScope.isBuilder
    scope.state       = $state.current.name
    scope.cart        = eeCart.cart
    return

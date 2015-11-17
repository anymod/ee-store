'use strict'

module = angular.module 'ee-storefront-header', []

module.directive "eeStorefrontHeader", ($rootScope, $state, $window, eeCart, eeModal) ->
  templateUrl: 'ee-shared/components/ee-storefront-header.html'
  scope:
    meta:           '='
    blocked:        '='
    fluid:          '@'
    loading:        '='
    collections:    '='
    quantityArray:  '='
  link: (scope, ele, attrs) ->
    scope.isStore     = $rootScope.isStore
    scope.isBuilder   = $rootScope.isBuilder
    scope.state       = $state.current.name
    scope.cart        = eeCart.cart
    scope.openCollectionsModal = () -> eeModal.fns.openCollectionsModal scope.collections

    position = $window.pageYOffset
    angular.element($window).bind 'scroll', (e, a, b) ->
      new_pos = $window.pageYOffset
      if new_pos < position then ele.removeClass 'slid-up'
      if new_pos > position + 30 then ele.addClass 'slid-up'
      if new_pos < position or new_pos > position + 30 then position = new_pos
      
    return

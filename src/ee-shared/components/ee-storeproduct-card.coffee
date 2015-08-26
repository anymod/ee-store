'use strict'

module = angular.module 'ee-storeproduct-card', []

module.directive "eeStoreproductCard", ($rootScope, $state, $cookies, eeBack) ->
  templateUrl: 'ee-shared/components/ee-storeproduct-card.html'
  restrict: 'E'
  scope:
    storeProduct: '='
    product:      '='
    disabled:     '='
    price:        '='
    # storeproductTitle:  '=' # storeproductTitle to avoid title="" in HTML (which causes popover note in some browsers)
    # price:              '='
    # content:            '='
    # mainImage:          '@'
    # image:              '@'
    # additionalImages:   '@'
    # details:            '='
    # outOfStock:         '='
    # discontinued:       '='
  link: (scope, ele, attrs) ->
    scope.addToCart = () -> $rootScope.$emit 'add:storeproduct', $state.params.id
    return

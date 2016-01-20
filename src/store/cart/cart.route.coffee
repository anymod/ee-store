'use strict'

angular.module('store.cart').config ($stateProvider) ->

  $stateProvider

    .state 'cart',
      url: '/cart'
      views:
        top:
          controller: 'storeCtrl as storefront'
          templateUrl: 'store/store.header.html'
        middle:
          controller:  'cartCtrl as cart'
          templateUrl: 'store/cart/cart.html'
        footer:
          controller: 'storeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.footer.html'

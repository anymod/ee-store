'use strict'

angular.module('store.product').config ($stateProvider) ->

  $stateProvider

    .state 'product',
      url: '/products/:id/:title?'
      views:
        top:
          controller: 'productCtrl as product'
          templateUrl: 'store/product/product.header.html'
        middle:
          controller: 'productCtrl as product'
          templateUrl: 'store/product/product.html'
        footer:
          controller: 'storeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.footer.html'
      params:
        title:
          value: null
          squash: true

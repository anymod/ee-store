'use strict'

angular.module('store.home').config ($stateProvider) ->

  $stateProvider

    .state 'storefront',
      url: '/'
      views:
        top:
          controller: 'storeCtrl as storefront'
          templateUrl: 'store/store.header.html'
        middle:
          controller: 'storeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.carousel.html'
        bottom:
          controller: 'homeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.featured.html'
        footer:
          controller: 'storeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.footer.html'

'use strict'

angular.module('store.collections').config ($stateProvider) ->

  $stateProvider

    .state 'collection',
      url: '/collections/:id?p&s&r'
      views:
        top:
          controller: 'storeCtrl as storefront'
          templateUrl: 'store/store.header.html'
        middle:
          controller: 'collectionCtrl as collection'
          templateUrl: 'store/collections/collection.html'
        footer:
          controller: 'storeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.footer.html'
      params:
        p: null # page
        s: null # sort
        r: null # range

    .state 'collections',
      url: '/collections'
      views:
        top:
          controller: 'storeCtrl as storefront'
          templateUrl: 'store/store.header.html'
        middle:
          controller: 'collectionsCtrl as collections'
          templateUrl: 'store/collections/collections.html'
        footer:
          controller: 'storeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.footer.html'

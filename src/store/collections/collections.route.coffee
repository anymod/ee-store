'use strict'

angular.module('store.collections').config ($stateProvider) ->

  $stateProvider

    .state 'collection',
      url: '/collections/:id/:title'
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
        p: null
        sort: null
        range: null

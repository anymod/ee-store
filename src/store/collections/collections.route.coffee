'use strict'

angular.module('store.collections').config ($stateProvider) ->

  $stateProvider

    .state 'collection',
      url: '/collections/:id/:title?q&p&s&r&coll'
      views:
        top:
          controller: 'storeCtrl as storefront'
          templateUrl: 'store/search/search.header.html'
          # templateUrl: 'store/store.header.html'
        middle:
          controller: 'searchCtrl as search'
          templateUrl: 'store/search/search.html'
          # controller: 'collectionCtrl as collection'
          # templateUrl: 'store/collections/collection.html'
        footer:
          controller: 'storeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.footer.html'
      params:
        q: null # query
        p: null # page
        s: null # sort
        r: null # range
        coll: null # collection
        title:
          value: null
          squash: true

    # .state 'collections',
    #   url: '/collections'
    #   views:
    #     top:
    #       controller: 'storeCtrl as storefront'
    #       templateUrl: 'store/store.header.html'
    #     middle:
    #       controller: 'collectionsCtrl as collections'
    #       templateUrl: 'store/collections/collections.html'
    #     footer:
    #       controller: 'storeCtrl as storefront'
    #       templateUrl: 'ee-shared/storefront/storefront.footer.html'

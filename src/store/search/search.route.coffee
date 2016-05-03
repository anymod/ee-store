'use strict'

angular.module('store.search').config ($stateProvider) ->

  $stateProvider

    .state 'search',
      url: '/search?q&p&s&r&c'
      views:
        top:
          controller: 'storeCtrl as storefront'
          templateUrl: 'store/search/search.header.html'
        middle:
          controller: 'searchCtrl as search'
          templateUrl: 'store/search/search.html'
        footer:
          controller: 'storeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.footer.html'
      params:
        q: null # query
        p: null # page
        s: null # sort
        r: null # range
        c: null # category
      data:
        pageTitle:        'Search'
        pageDescription:  'Search our products'
        padTop:           '51px'

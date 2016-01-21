'use strict'

angular.module('store.search').config ($stateProvider) ->

  $stateProvider

    .state 'search',
      url: '/search?q&p&s&r'
      views:
        top:
          controller: 'storeCtrl as storefront'
          templateUrl: 'store/store.header.html'
        middle:
          controller: 'searchCtrl as search'
          templateUrl: 'ee-shared/storefront/storefront.search.html' #'store/search/search.html'
        footer:
          controller: 'storeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.footer.html'
      params:
        q: null # query
        p: null # page
        s: null # sort
        r: null # range
      data:
        pageTitle:        'Search'
        pageDescription:  'Search our products'
        padTop:           '51px'

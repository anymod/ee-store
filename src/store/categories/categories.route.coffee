'use strict'

angular.module('store.categories').config ($stateProvider) ->

  $stateProvider

    .state 'category',
      url: '/categories/:id/:title?p&s&r'
      views:
        top:
          controller: 'storeCtrl as storefront'
          templateUrl: 'store/search/search.header.html'
        middle:
          controller: 'categoryCtrl as category'
          templateUrl: 'store/categories/category.html'
        footer:
          controller: 'storeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.footer.html'
      params:
        p: null # page
        s: null # sort
        r: null # range
      data:
        pageTitle:        'Search'
        pageDescription:  'Search our products'
        padTop:           '51px'

'use strict'

angular.module('store.categories').config ($stateProvider) ->

  $stateProvider

    .state 'category',
      url: '/categories/:id/:title?p&sort&range'
      views:
        top:
          controller: 'storeCtrl as storefront'
          templateUrl: 'store/store.header.html'
        middle:
          controller: 'categoryCtrl as category'
          templateUrl: 'store/categories/category.html'
        footer:
          controller: 'storeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.footer.html'
      params:
        p: null
        sort: null
        range: null
      data:
        pageTitle:        'Search'
        pageDescription:  'Search our products'
        padTop:           '51px'

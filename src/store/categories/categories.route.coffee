'use strict'

angular.module('store.categories').config ($stateProvider) ->

  $stateProvider

    .state 'category',
      url: '/categories/:id/:title'
      views:
        top:
          controller: 'storeCtrl as storefront'
          templateUrl: 'store/search/search.header.html'
        middle:
          controller: 'categoryCtrl as search'# 'categoryCtrl as category'
          templateUrl: 'ee-shared/storefront/storefront.search.html' # 'store/categories/category.html'
        footer:
          controller: 'storeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.footer.html'
      data:
        pageTitle:        'Search'
        pageDescription:  'Search our products'
        padTop:           '51px'

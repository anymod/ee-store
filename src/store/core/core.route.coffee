'use strict'

angular.module('store.core').config ($stateProvider, $urlRouterProvider) ->

  aboutViews =
    top:
      controller: 'storeCtrl as storefront'
      templateUrl: 'store/store.header.html'
    middle:
      controller: 'storeCtrl as storefront'
      templateUrl: 'ee-shared/storefront/storefront.about.html'
    footer:
      controller: 'storeCtrl as storefront'
      templateUrl: 'ee-shared/storefront/storefront.footer.html'

  $stateProvider

    .state 'storefront-about',
      url:      '/about'
      views:    aboutViews

  $urlRouterProvider.otherwise '/'
  return

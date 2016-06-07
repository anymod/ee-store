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

    .state 'terms',
      url: '/terms'
      views:
        top:
          controller: 'storeCtrl as storefront'
          templateUrl: 'store/store.header.html'
        middle:
          controller: 'storeCtrl as storefront'
          templateUrl: 'store/store.terms.html'
        footer:
          controller: 'storeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.footer.html'

    .state 'privacy',
      url: '/privacy'
      views:
        top:
          controller: 'storeCtrl as storefront'
          templateUrl: 'store/store.header.html'
        middle:
          controller: 'storeCtrl as storefront'
          templateUrl: 'store/store.privacy.html'
        footer:
          controller: 'storeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.footer.html'


  $urlRouterProvider.otherwise '/'
  return

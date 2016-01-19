'use strict'

angular.module('store.core').config ($locationProvider, $stateProvider, $urlRouterProvider, $httpProvider) ->

  views =
    top:
      controller: 'storeCtrl as storefront'
      templateUrl: 'store/store.header.html'
    middle:
      controller: 'storeCtrl as storefront'
      templateUrl: 'ee-shared/storefront/storefront.carousel.html'
    bottom:
      controller: 'storeCtrl as storefront'
      templateUrl: 'ee-shared/storefront/storefront.featured.html'
    footer:
      controller: 'storeCtrl as storefront'
      templateUrl: 'ee-shared/storefront/storefront.footer.html'

  aboutViews =
    top:
      controller: 'storeCtrl as storefront'
      templateUrl: 'store/store.header.html'
    middle:
      controller: 'storeCtrl as storefront'
      templateUrl: 'ee-shared/storefront/storefront.about.html'
    footer: views.footer

  data =
    pageTitle:        ''
    pageDescription:  ''
    padTop:           '51px'

  $stateProvider

    .state 'storefront',
      url:      '/'
      views:    views
      data:     data

    .state 'storefront-about',
      url:      '/about'
      views:    aboutViews
      data:     data

    .state 'cart',
      url: '/cart'
      views:
        top: views.top
        middle:
          controller:  'cartCtrl as cart'
          templateUrl: 'store/cart/cart.html'
        footer: views.footer
      data:
        padTop: '51px'

    .state 'cart-success',
      url: '/cart/success'
      views:
        top: views.top
        middle:
          controller:  'cartCtrl as cart'
          templateUrl: 'store/cart/success.html'
        footer: views.footer
      data:
        padTop: '51px'

  $urlRouterProvider.otherwise '/'
  return

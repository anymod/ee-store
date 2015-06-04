'use strict'

angular.module('store.core').config ($locationProvider, $stateProvider, $urlRouterProvider, $httpProvider) ->

  views =
    header:
      controller: 'storeCtrl as storefront'
      templateUrl: 'store/store.header.html'
    top:
      controller: 'storeCtrl as storefront'
      templateUrl: 'app/storefront/storefront.carousel.html'
    middle:
      controller: 'storeCtrl as storefront'
      templateUrl: 'app/storefront/storefront.products.html'
    footer:
      controller: 'storeCtrl as storefront'
      templateUrl: 'app/storefront/storefront.footer.html'

  shopViews =
    header: views.header
    top:    views.middle
    footer: views.footer

  aboutViews =
    header: views.header
    top:
      controller: 'storeCtrl as storefront'
      templateUrl: 'app/storefront/storefront.about.html'
    footer: views.footer

  data =
    pageTitle:        'Add products | eeosk'
    pageDescription:  'Choose products to add to your store.'
    padTop:           '51px'

  $stateProvider

    .state 'storefront',
      url:      '/'
      views:    views
      data:     data

    .state 'storefront-shop',
      url:      '/shop'
      views:    shopViews
      data:     data

    .state 'storefront-shop-category',
      url:      '/shop/:category'
      views:    shopViews
      data:     data

    .state 'storefront-about',
      url:      '/about'
      views:    aboutViews
      data:     data

    .state 'cart',
      url: '/cart'
      views:
        header: views.header
        top:
          controller:  'cartCtrl as cart'
          templateUrl: 'store/cart/cart.html'
        footer: views.footer
      data:
        padTop: '51px'

    .state 'cart-success',
      url: '/cart/success'
      views:
        header: views.header
        top:
          controller:  'cartCtrl as cart'
          templateUrl: 'store/cart/success.html'
        footer: views.footer
      data:
        padTop: '51px'

  $urlRouterProvider.otherwise '/'
  return

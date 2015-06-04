'use strict'

angular.module('builder.storefront').config ($stateProvider) ->

  views =
    header:
      controller: 'storefrontCtrl as storefront'
      templateUrl: 'builder/storefront/storefront.header.html'
    top:
      controller: 'storefrontCtrl as storefront'
      templateUrl: 'app/storefront/storefront.carousel.html'
    middle:
      controller: 'storefrontCtrl as storefront'
      templateUrl: 'app/storefront/storefront.products.html'
    bottom:
      controller: 'storefrontCtrl as storefront'
      templateUrl: 'builder/storefront/storefront.add.html'
    footer:
      controller: 'storefrontCtrl as storefront'
      templateUrl: 'app/storefront/storefront.footer.html'

  shopViews =
    header: views.header
    top:    views.middle
    middle: views.bottom
    footer: views.footer

  aboutViews =
    header: views.header
    top:
      controller: 'storefrontCtrl as storefront'
      templateUrl: 'app/storefront/storefront.about.html'
    footer: views.footer

  data =
    pageTitle:        'My store | eeosk'
    pageDescription:  'Preview and navigate my eeosk.'
    padTop:           '100px'

  $stateProvider
    .state 'try-storefront',
      url:      '/try/storefront'
      views:    views
      data:     data

    .state 'storefront',
      url:      '/storefront'
      views:    views
      data:     data

    .state 'storefront-shop',
      url:      '/storefront/shop'
      views:    shopViews
      data:     data

    .state 'storefront-shop-category',
      url:      '/storefront/shop/:category'
      views:    shopViews
      data:     data

    .state 'storefront-about',
      url:      '/storefront/about'
      views:    aboutViews
      data:     data

  return

'use strict'

angular.module('builder.catalog').config ($stateProvider) ->

  views =
    header:
      controller: 'catalogCtrl as catalog'
      templateUrl: 'builder/catalog/catalog.header.html'
    top:
      controller: 'catalogCtrl as catalog'
      templateUrl: 'builder/catalog/catalog.popover.html'
    # middle:
    #   controller: 'storefrontCtrl as storefront'
    #   templateUrl: 'app/storefront/storefront.products.html'
    bottom:
      controller: 'catalogCtrl as catalog'
      templateUrl: 'builder/catalog/catalog.html'

  data =
    pageTitle:        'Add products | eeosk'
    pageDescription:  'Choose products to add to your store.'
    padTop:           '88px'

  $stateProvider
    .state 'try-catalog',
      url:      '/try/products'
      views:    views
      data:     data

    .state 'catalog',
      url:      '/products'
      views:    views
      data:     data

  return

'use strict'

angular.module('builder.landing').config ($stateProvider) ->

  views =
    header:
      controller: 'storefrontCtrl as storefront'
      templateUrl: 'builder/storefront/storefront.header.html'
    top:
      controller: 'storefrontCtrl as storefront'
      templateUrl: 'app/storefront/storefront.carousel.html'
    middle:
      controller: 'editCtrl as edit'
      templateUrl: 'builder/edit/edit.html'

  try_data =
    pageTitle:        'Try it out: build your online store | eeosk'
    pageDescription:  'Start building your own online store.'
    padTop:           '100px'

  data =
    pageTitle:        'Edit your store | eeosk'
    pageDescription:  'Edit the look and feel of your online store.'
    padTop:           '100px'

  $stateProvider
    .state 'try-edit',
      url:      '/try/edit'
      views:    views
      data:     try_data

    .state 'edit',
      url:      '/edit'
      views:    views
      data:     data

  return

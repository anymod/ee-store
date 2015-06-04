'use strict'

angular.module('builder.landing').config ($stateProvider, $locationProvider) ->

  $stateProvider.state 'landing_old',
    url: '/landing'
    views:
      'top-view':
        controller: 'landingCtrl'
        templateUrl: 'builder/landing/landing.html'
      'bottom-view':
        templateUrl: 'builder/templates/template.offscreen.default.html'
    data:
      pageTitle:        'Online store builder, ecommerce storefront, dropship product catalog | eeosk'
      pageDescription:  'Create an online store from a catalog of products.'

  return

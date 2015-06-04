'use strict'

angular.module('builder.landing').config ($stateProvider, $locationProvider) ->

  $stateProvider
    .state 'landing',
      url: '/'
      views:
        bottom:
          controller: 'landingCtrl as landing'
          templateUrl: 'builder/landing/landing.html'
        footer:
          controller: 'landingCtrl as landing'
          templateUrl: 'builder/landing/landing.footer.html'
      data:
        pageTitle:        'Online store builder, ecommerce storefront, dropship product catalog | eeosk'
        pageDescription:  'Create an online store in minutes.'

    .state 'try-theme',
      url: '/try/choose-theme'
      views:
        top:
          controller: 'landingCtrl as landing'
          templateUrl: 'builder/landing/landing.html'
        bottom:
          controller: 'landingCtrl as landing'
          templateUrl: 'builder/landing/landing.theme.html'
      data:
        pageTitle:        'Choose a theme for your store | eeosk'
        pageDescription:  'Start building your store by choosing a theme (you can edit it next).'

    .state 'welcome',
      url: '/welcome'
      views:
        bottom:
          controller: 'landingCtrl as landing'
          templateUrl: 'builder/landing/landing.html'
        footer:
          controller: 'landingCtrl as landing'
          templateUrl: 'builder/landing/landing.footer.html'
      data:
        pageTitle:        'Welcome to eeosk'
        pageDescription:  'Create an online store in minutes.'

  return

'use strict'

angular.module('builder.terms').config ($stateProvider) ->

  $stateProvider
    .state 'terms',
      url: '/terms'
      views:
        top:
          templateUrl: 'builder/terms/terms.html'
          controller: 'termsCtrl'
      data:
        pageTitle: 'Terms & Conditions | eeosk'
        
    .state 'privacy',
      url: '/privacy'
      views:
        top:
          templateUrl: 'builder/terms/privacy.html'
          controller: 'termsCtrl'
      data:
        pageTitle: 'Privacy Policy | eeosk'

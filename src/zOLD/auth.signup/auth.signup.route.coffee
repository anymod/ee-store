'use strict'

angular.module('builder.auth').config ($stateProvider) ->

  $stateProvider
    .state 'signup',
      url: '/create-online-store'
      views:
        top:
          controller: 'signupCtrl as signup'
          templateUrl: 'builder/auth.signup/auth.signup.html'
        footer:
          controller: 'landingCtrl as landing'
          templateUrl: 'builder/landing/landing.footer.html'
      data:
        pageTitle: 'Create your store | eeosk'

  return

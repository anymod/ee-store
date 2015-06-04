'use strict'

angular.module('builder.auth').config ($stateProvider) ->

  $stateProvider
    .state 'logout',
      url: '/logout'
      views:
        top:
          controller: 'logoutCtrl'
          templateUrl: 'builder/auth.logout/auth.logout.html'
        footer:
          controller:   'landingCtrl as landing'
          templateUrl:  'builder/landing/landing.footer.html'
      data:
        pageTitle: 'Logged out | eeosk'

  return

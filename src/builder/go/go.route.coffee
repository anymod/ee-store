'use strict'

angular.module('builder.go').config ($stateProvider, $locationProvider) ->

  $stateProvider
    .state 'go',
      url: '/go/:token'
      views:
        top:
          controller: 'goCtrl as go'
          templateUrl: 'builder/go/go.html'
      data:
        pageTitle:    'You\'re signed up! | eeosk'

  return

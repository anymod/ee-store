'use strict'

angular.module('builder.auth').config ($stateProvider) ->

  $stateProvider
    .state 'reset',
      url: '/reset-password'
      views:
        top:
          controller: 'resetCtrl as reset'
          templateUrl: 'builder/auth.reset/auth.reset.html'
      data:
        pageTitle: 'Reset your password | eeosk'

  return

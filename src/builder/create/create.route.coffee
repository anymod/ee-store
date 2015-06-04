'use strict'

angular.module('builder.create').config ($stateProvider, $locationProvider) ->

  $stateProvider
    .state 'create',
      url: '/create/:token'
      views:
        top:
          controller: 'createCtrl as create'
          templateUrl: 'builder/create/create.html'
      data:
        pageTitle:        'Create your store'

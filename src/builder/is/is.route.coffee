'use strict'

angular.module('builder.is').config ($stateProvider, $locationProvider) ->

  $stateProvider

    .state 'your-own-business',
      url: '/is/your-own-business'
      views:
        top:
          templateUrl: 'builder/is/your-own-business.html'
          controller: 'isCtrl as is'
      data: pageTitle: 'eeosk is your own business'

    .state 'easy-to-use',
      url: '/is/easy-to-use'
      views:
        top:
          templateUrl: 'builder/is/easy-to-use.html'
          controller: 'isCtrl as is'
      data: pageTitle: 'eeosk is easy to use'

    .state 'everything-you-need',
      url: '/is/everything-you-need'
      views:
        top:
          templateUrl: 'builder/is/everything-you-need.html'
          controller: 'isCtrl as is'
      data: pageTitle: 'eeosk is everything you need to start'

    .state 'beautiful-and-customizable',
      url: '/is/beautiful-and-customizable'
      views:
        top:
          templateUrl: 'builder/is/beautiful-and-customizable.html'
          controller: 'isCtrl as is'
      data: pageTitle: 'eeosk is beautiful and customizable'

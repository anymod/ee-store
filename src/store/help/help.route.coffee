'use strict'

angular.module('store.help').config ($stateProvider) ->

  $stateProvider

    .state 'help',
      url: '/help'
      views:
        top:
          controller: 'storeCtrl as storefront'
          templateUrl: 'store/store.header.html'
        middle:
          controller: 'helpCtrl as help'
          templateUrl: 'store/help/help.html'
        footer:
          controller: 'storeCtrl as storefront'
          templateUrl: 'ee-shared/storefront/storefront.footer.html'
      data:
        pageTitle:        'Help'
        padTop:           '51px'

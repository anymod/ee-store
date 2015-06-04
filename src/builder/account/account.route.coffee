'use strict'

angular.module('builder.account').config ($stateProvider) ->

  $stateProvider.state 'account',
    url: '/account'
    views:
      header:
        controller:  'accountCtrl as account'
        templateUrl: 'builder/account/account.header.html'
      top:
        controller:  'accountCtrl as account'
        templateUrl: 'builder/account/account.html'
    data:
      pageTitle: 'Account | eeosk'
      padTop:    '50px'

  return

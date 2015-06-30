'use strict'

angular.module 'ee-shop-nav', []

angular.module('ee-shop-nav').directive "eeShopNav", ($state) ->
  templateUrl: 'ee-shared/components/ee-shop-nav.html'
  restrict: 'E'
  replace: true
  scope:
    collections: '='
  link: (scope, ele, attrs) ->
    scope.$state = $state
    return

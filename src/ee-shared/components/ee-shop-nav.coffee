'use strict'

angular.module 'ee-collection-nav', []

angular.module('ee-collection-nav').directive "eeShopNav", ($state) ->
  templateUrl: 'ee-shared/components/ee-collection-nav.html'
  restrict: 'E'
  replace: true
  scope:
    collections: '='
  link: (scope, ele, attrs) ->
    scope.$state = $state
    return

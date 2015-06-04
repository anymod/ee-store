'use strict'

angular.module('ee-product').directive "eeShopNav", ($state) ->
  templateUrl: 'ee-shared/components/ee-shop-nav.html'
  restrict: 'E'
  replace: true
  scope:
    categories: '='
  link: (scope, ele, attrs) ->
    scope.$state = $state
    return

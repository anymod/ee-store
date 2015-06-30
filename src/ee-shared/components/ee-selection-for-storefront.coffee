'use strict'

angular.module 'ee-selection-for-storefront', []

angular.module('ee-selection-for-storefront').directive "eeSelectionForStorefront", () ->
  templateUrl: 'ee-shared/components/ee-selection-for-storefront.html'
  restrict: 'E'
  scope:
    selection: '='
  link: (scope, ele, attr) ->
    return

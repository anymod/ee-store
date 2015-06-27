'use strict'

angular.module('ee-product').directive "eeProductForStorefront", (eeProduct) ->
  templateUrl: 'ee-shared/components/ee-product-for-storefront.html'
  restrict: 'E'
  scope:
    selection: '='
  link: (scope, ele, attr) ->
    return

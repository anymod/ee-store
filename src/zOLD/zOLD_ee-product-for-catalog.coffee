'use strict'

angular.module('ee-product').directive "eeProductForCatalog", (eeStorefront, eeCatalog, eeAuth, eeSelection) ->
  templateUrl: 'components/ee-product-for-catalog.html'
  restrict: 'E'
  scope:
    product: '='

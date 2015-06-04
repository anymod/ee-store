'use strict'

angular.module('ee-product').directive "eeProductMarginSetter", (eeCatalog) ->
  templateUrl: 'components/ee-product-margin-setter.html'
  restrict: 'E'
  require: "^eeProductForCatalog"
  scope:
    product: '='
    disabled: '='
  link: (scope, ele, attr, eeProductForCatalogCtrl) ->
    basePrice = scope.product.baseline_price
    scope.margin_array = eeCatalog.margin_array
    eeCatalog.setCurrents scope, basePrice, eeCatalog.start_margin

    scope.update = (newMargin) ->
      eeProductForCatalogCtrl.setCurrentMargin newMargin
      eeCatalog.setCurrents scope, basePrice, newMargin

    return

'use strict'

module = angular.module 'ee-product-builder-buttons', []

module.directive "eeProductBuilderButtons", (eeCustomization, eeProducts, eeCollections) ->
  templateUrl: 'ee-shared/components/ee-product-builder-buttons.html'
  restrict: 'E'
  scope:
    product:    '='
    collection: '='
    buttonSet:  '='
    btnClass:   '@'
  link: (scope, ele, attrs) ->
    scope.customizationFns  = eeCustomization.fns
    scope.productsFns       = eeProducts.fns
    scope.collectionsFns    = eeCollections.fns

    scope.add = () ->
      eeCollections.fns.addProduct(scope.collection, scope.product)
      .then () -> scope.buttonSet = 'remove'

    scope.remove = () ->
      eeCollections.fns.removeProduct(scope.collection, scope.product)
      .then () -> scope.buttonSet = 'add'
    return

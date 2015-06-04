'use strict'

angular.module('ee-product').directive "eeProductSelectionButton", (eeSelection, eeStorefront, eeAuth) ->
  templateUrl: 'components/ee-product-selection-button.html'
  restrict: 'E'
  scope:
    product: '='
  link: (scope, ele, attr, eeProductForCatalogCtrl) ->
    scope.removeProductFromStore = () ->
      name = ''
      eeAuth.getUsername()
      .then (username) ->
        name = username
        eeSelection.deleteSelection(scope.product.selection_id)
      .catch (err) -> console.error err
      .finally () -> eeStorefront.getStorefront(true)
    return

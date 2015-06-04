'use strict'

angular.module('ee-product').directive "eeProductDetail", ($state, eeStorefront, eeAuth) ->
  templateUrl: 'components/ee-product-detail.html'
  restrict: 'E'
  scope:
    product: '='
  link: (scope, ele, attr) ->
    scope.isBuilder   = eeStorefront.isBuilder()
    scope.isStore     = eeStorefront.isStore()
    scope.isntCatalog = $state.current.name.indexOf('catalog') < 0

    scope.focusImg    = scope.product?.image_meta?.main_image
    scope.setFocusImg = (img) -> scope.focusImg = img

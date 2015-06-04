'use strict'

angular.module('ee-product').directive "eeProductForStorefront", (eeProduct) ->
  templateUrl: 'components/ee-product-for-storefront.html'
  restrict: 'E'
  scope:
    product: '='
  link: (scope, ele, attr) ->
    id = scope.product.id or scope.product.product_id
    scope.openModal = () -> eeProduct.fns.openProductModal id
    return

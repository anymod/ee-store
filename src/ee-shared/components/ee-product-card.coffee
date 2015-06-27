'use strict'

module = angular.module 'ee-product-card', []

module.directive "eeProductCard", () ->
  templateUrl: 'ee-shared/components/ee-product-card.html'
  restrict: 'E'
  scope:
    title:      '='
    price:      '='
    content:    '='
    mainImage:  '@'
    details:    '='
  link: (scope, ele, attrs) ->
    scope.setMainImage = (url) -> scope.mainImage = url
    return

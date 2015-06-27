'use strict'

module = angular.module 'ee-selection-card', []

module.directive "eeSelectionCard", () ->
  templateUrl: 'ee-shared/components/ee-selection-card.html'
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

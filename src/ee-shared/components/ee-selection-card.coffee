'use strict'

module = angular.module 'ee-selection-card', []

module.directive "eeSelectionCard", ($rootScope, $state, $cookies, eeBack) ->
  templateUrl: 'ee-shared/components/ee-selection-card.html'
  restrict: 'E'
  scope:
    selectionTitle: '=' # selectionTitle to avoid title="" in HTML (which causes popover note in some browsers)
    price:          '='
    content:        '='
    mainImage:      '@'
    details:        '='
    disabled:       '@'
  link: (scope, ele, attrs) ->
    scope.setMainImage = (url) -> scope.mainImage = url
    scope.addToCart = () -> $rootScope.$emit 'add:selection', $state.params.id
    return

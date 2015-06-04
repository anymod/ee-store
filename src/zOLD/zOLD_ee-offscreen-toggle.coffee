'use strict'

angular.module 'ee-offscreen-toggle', []

angular.module('ee-offscreen-toggle').directive "eeOffscreenToggle", ($rootScope) ->
  templateUrl: 'components/ee-offscreen-toggle.html'
  restrict: 'E'
  replace: true
  scope:
    color: '='
    icon: '='
  link: (scope, ele, attrs) ->
    scope.toggleOffscreen = () -> $rootScope.toggleLeft = !$rootScope.toggleLeft
    return

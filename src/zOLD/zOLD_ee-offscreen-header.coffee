'use strict'

angular.module 'ee-offscreen-header', []

angular.module('ee-offscreen-header').directive "eeOffscreenHeader", () ->
  templateUrl: 'components/ee-offscreen-header.html'
  restrict: 'E'
  replace: true
  link: (scope, ele, attrs) ->
    return

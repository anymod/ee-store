'use strict'

angular.module 'ee-example-store', []

angular.module('ee-example-store').directive "eeExampleStore", ($rootScope, $location, $anchorScroll) ->
  templateUrl: 'components/ee-example-store.html'
  scope:
    show: '='
  link: (scope, ele, attrs) ->
    return

'use strict'

angular.module 'ee-scroller', []

angular.module('ee-scroller').directive "eeScroller", ($rootScope, $document) ->
  link: (scope, element, attrs) ->
    distance = 0
    $rootScope.pin =
      bottom: false

    setPinBottom = (state) ->
      $rootScope.pin.bottom = state
      $rootScope.$apply()

    $document.on 'scroll', () ->
      distance = element[0].getBoundingClientRect().top
      if distance <= 1
        setPinBottom true
      else if $rootScope.pin.bottom
        setPinBottom false
    return

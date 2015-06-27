'use strict'

angular.module('store.core').run ($rootScope, $window, $location, eeStorefront) ->
  $rootScope.isStore = true
  $rootScope.$on '$stateChangeStart', (e, toState, toParams, fromState, fromParams) ->
    # TODO eeFetcher service for store only
    if !!fromState.name
      eeStorefront.data.loading = true
      $location.path(toState.url)
      $window.location.reload()
  return

'use strict'

angular.module('store.core').run ($rootScope, $window) ->
  $rootScope.isStore = true

  n = 0
  $rootScope.$on '$stateChangeStart', (e, toState, toParams, fromState, fromParams) ->
    if n is 1
      e.preventDefault()
      frags = toState.url.replace(/\//g, '').split(':')
      protocol  = $window.location.protocol
      host      = $window.location.href.split('//')[1].split('/')[0]
      path      = '/' + frags[0]
      if frags[1] and toParams[frags[1]] then path = path + '/' + toParams[frags[1]]
      if frags[2] and toParams[frags[2]] then path = path + '/' + toParams[frags[2]]
      $window.location.assign(protocol + '//' + host + path)
    n += 1

  return

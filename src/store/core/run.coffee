'use strict'

angular.module('store.core').run ($rootScope, $window, $cookies, eeModal, eeBootstrap) ->
  $rootScope.isStore = true

  $rootScope.forceReload = (path, params) ->
    protocol  = $window.location.protocol
    host      = $window.location.href.split('//')[1].split('/')[0]
    path    ||= ''
    query = if params then '?' else ''
    params  ||= {}
    for key in Object.keys(params)
      # Remove non-whitespace then trim then replace space with +
      value = if key is 'q' then params[key]?.replace(/[^\w\s-]/g, '')?.replace(/^\s+|\s+$/g, '')?.replace(/ /g, '+') else params[key]
      if value then query += '' + key + '=' + value + '&'
    $window.location.assign(protocol + '//' + host + path + query)

  n = 0
  $rootScope.$on '$stateChangeStart', (e, toState, toParams, fromState, fromParams) ->
    if n is 1
      e.preventDefault()
      frags = toState.url.replace(/\//g, '').split(':')
      path  = '/' + frags[0]
      if frags[1] and toParams[frags[1]] then path = path + '/' + toParams[frags[1]]
      if frags[2] and toParams[frags[2]] then path = path + '/' + toParams[frags[2]]
      console.log 'toParams', toParams
      params = if toState.name is 'search' then toParams else null
      $rootScope.forceReload path, params
    n += 1

  if eeBootstrap.username is 'stylishrustic' and !$cookies.offered then $rootScope.mouseleave = () ->
    $cookies.offered = true
    eeModal.fns.open 'offer'
    $rootScope.mouseleave = () -> false

  return

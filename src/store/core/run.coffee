'use strict'

angular.module('store.core').run ($rootScope, $window, $cookies, $location, eeModal, eeBootstrap) ->
  $rootScope.isStore = true

  ## Keen.js
  keen = new Keen
    projectId: '565c9b27c2266c0bb36521db',
    writeKey: 'a36f4230d8a77258c853d2bcf59509edc5ae16b868a6dbd8d6515b9600086dbca7d5d674c9307314072520c35f462b79132c2a1654406bdf123aba2e8b1e880bd919482c04dd4ce9801b5865f4bc95d72fbe20769bc238e1e6e453ab244f9243cf47278e645b2a79398b86d7072cb75c'

  $rootScope.forceReload = (path, query) ->
    protocol  = $window.location.protocol
    host      = $window.location.href.split('//')[1].split('/')[0]
    path    ||= ''
    query   ||= ''
    $window.location.assign(protocol + '//' + host + path + query)

  n = 0
  $rootScope.$on '$stateChangeStart', (e, toState, toParams, fromState, fromParams) ->
    if n > 0
      e.preventDefault()
      frags = toState.url.replace(/\//g, '').split(':')
      # Path
      path  = '/' + frags[0]
      if frags[1] and toParams[frags[1]] then path = path + '/' + toParams[frags[1]]
      if frags[2] and toParams[frags[2]] then path = path + '/' + toParams[frags[2]]
      # Query
      params  = toParams || {}
      keys    = Object.keys(params)
      query   = if keys.length > 0 then '?' else ''
      for key in keys
        # If a query, remove non-whitespace and trim, then replace space with +
        value = null
        if key is 'q' or key is 'p' then value = toParams[key]
        if toState.name is 'search' and key is 'q' then value = value?.replace(/[^\w\s-]/g, '')?.replace(/^\s+|\s+$/g, '')?.replace(/ /g, '+')
        if value then query += '' + key + '=' + value + '&'
      query = query.replace /[&?]$/g, ''
      # Reload
      $rootScope.forceReload path, query
    n++

  if eeBootstrap.username is 'stylishrustic' and !$cookies.offered then $rootScope.mouseleave = () ->
    $cookies.offered = true
    eeModal.fns.open 'offer'
    $rootScope.mouseleave = () -> false

  $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
    if !$cookies._ee then $cookies._ee = Math.random().toString(36).substr(2,8);
    if $location.search().s is 't'
      $cookies._eeself = true
      $location.search 's', null
    keenio =
      user:       eeBootstrap.tr_uuid
      url:        $location.absUrl()
      path:       $location.path()
      toState:    toState?.name
      toParams:   toParams
      fromState:  fromState?.name
      fromParams: fromParams
      self:       !!$cookies._eeself
      _ee:        $cookies._ee
      _ga:        $cookies._ga
      _gat:       $cookies._gat

    if keenio.user then keen.addEvent 'store', keenio, (err, res) -> return

    return

  return

'use strict'

angular.module('store.core').run ($rootScope, $window, $cookies, $location, eeModal, eeBootstrap) ->

  ## Setup
  $rootScope.isStore = true
  $rootScope.pageDepth = 0
  # Set referer domain to make filtering easier
  $rootScope.refererDomain = if eeBootstrap.referer then new URL(eeBootstrap.referer).hostname else null
  if $rootScope.refererDomain
    if $rootScope.refererDomain.indexOf('google.') > -1 then $rootScope.refererDomain = 'Google'
    else if $rootScope.refererDomain.indexOf('facebook.') > -1 or $rootScope.refererDomain.indexOf('fb.me') > -1 then $rootScope.refererDomain = 'Facebook'
    else if $rootScope.refererDomain.indexOf('pinterest.') > -1 then $rootScope.refererDomain = 'Pinterest'
    else if $rootScope.refererDomain.indexOf('twitter.') > -1 or $rootScope.refererDomain is 't.co' then $rootScope.refererDomain = 'Twitter'
    else if $rootScope.refererDomain.indexOf('instagram.') > -1 then $rootScope.refererDomain = 'Instagram'
  $rootScope.stateChange =
    toState: null
    toParams: null
    fromState: null
    fromParams: null

  ## Keen.js
  keen = new Keen
    projectId: '565c9b27c2266c0bb36521db',
    writeKey: 'a36f4230d8a77258c853d2bcf59509edc5ae16b868a6dbd8d6515b9600086dbca7d5d674c9307314072520c35f462b79132c2a1654406bdf123aba2e8b1e880bd919482c04dd4ce9801b5865f4bc95d72fbe20769bc238e1e6e453ab244f9243cf47278e645b2a79398b86d7072cb75c'
  keenio = {}
  setKeenio = () ->
    keenio =
      user:           eeBootstrap.tr_uuid
      referer:        eeBootstrap.referer
      refererDomain:  $rootScope.refererDomain
      url:            $location.absUrl()
      host:           $location.host()
      path:           $location.path()
      toState:        $rootScope.stateChange?.toState?.name
      toParams:       $rootScope.stateChange?.toParams
      fromState:      $rootScope.stateChange?.fromState?.name
      fromParams:     $rootScope.stateChange?.fromParams
      pageDepth:      $rootScope.pageDepth
      signupModalDepth: $cookies.get('offered')
      windowWidth:    $window.innerWidth
      self:           !!$cookies.get('_eeself')
      _ee:            $cookies.get('_ee')
      _ga:            $cookies.get('_ga')
      _gat:           $cookies.get('_gat')
  setKeenio()
  $rootScope.$on 'keen:addEvent', (e, title) ->
    return if $location.host() is 'localhost' or !title?
    setKeenio()
    keen.addEvent title, keenio

  if eeBootstrap.username is 'stylishrustic' and !$cookies.get('offered')
    $rootScope.mouseleave = () ->
      $cookies.put 'offered', ($rootScope.pageDepth || true)
      eeModal.fns.open 'offer'
      $rootScope.mouseleave = () -> false

  # Broadcast page reset on stateChangeStart and stateChangeSuccess to remove page param
  $rootScope.$on '$stateChangeStart', (e, toState, toParams, fromState, fromParams) ->
    if $rootScope.pageDepth > 1 and (toState.name isnt fromState.name or toParams.id isnt fromParams.id) then $rootScope.$broadcast 'reset:page'

  $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
    $rootScope.pageDepth++
    $rootScope.stateChange =
      toState:    toState?.name
      toParams:   toParams
      fromState:  fromState?.name
      fromParams: fromParams

    if $rootScope.pageDepth > 1 and (toState.name isnt fromState.name or toParams.id isnt fromParams.id) then $rootScope.$broadcast 'reset:page'

    if !$cookies.get('_ee')
      d = new Date()
      str = '' + ('' + d.getFullYear()).slice(-2) + ('0' + d.getUTCMonth()).slice(-2) + ('0' + d.getUTCDay()).slice(-2) + '.' + Math.random().toString().substr(2,8)
      $cookies.put '_ee', str
    if $location.search().s is 't'
      $cookies.put '_eeself', true
      $location.search 's', null

    $rootScope.$emit 'keen:addEvent', 'store'

    return

  return

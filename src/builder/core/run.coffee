'use strict'

angular.module('builder.core').run ($rootScope, $state, $location, $anchorScroll, eeAuth) ->
  $rootScope.isBuilder = true

  tryStates = [
    'try-theme'
    'try-storefront'
    'try-edit'
    'try-catalog'
  ]
  openStates = tryStates.concat [
    'landing'
    'terms'
    'privacy'
    'welcome'
    'login'
    'reset'
    'logout'
    'example'
    'go'
    'create'
    'your-own-business'
    'easy-to-use'
    'everything-you-need'
    'beautiful-and-customizable'
  ]

  isTry     = (state) -> tryStates.indexOf(state) > -1
  isntTry   = (state) -> !isTry state
  isOpen    = (state) -> openStates.indexOf(state) > -1
  needsAuth = (state) -> !isOpen state

  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
    loggedIn  = eeAuth.fns.hasToken()
    loggedOut = !loggedIn

    stopAndRedirectTo = (state) ->
      event.preventDefault()
      $state.go state
      # If redirect loop: $state.go causes this with child state, so use $location.path for storefront instead. See https://github.com/angular-ui/ui-router/issues/1169
      return

    # redirect to logged in state if token and try- state
    if loggedIn and isTry(toState.name) then return stopAndRedirectTo(toState.name.replace('try-', ''))
    # redirect to try- state if going from try- state to another state that needs auth
    if loggedOut and isTry(fromState.name) and isntTry(toState.name) and needsAuth(toState.name) then return stopAndRedirectTo('try-' + toState.name)
    # redirect to login if logged out and restricted
    if loggedOut and needsAuth(toState.name) then return stopAndRedirectTo('login')
    # redirect to storefront if logged in and unrestricted
    if loggedIn and isOpen(toState.name) and toState.name isnt 'logout' and toState.name isnt 'reset' then return stopAndRedirectTo('storefront')

    return

  return

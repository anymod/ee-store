'use strict'

angular.module('store.core').factory 'eeDefiner', ($rootScope, eeBootstrap, eeUser, eeProducts, eeCollections, eeCategorizations) ->

  ## SETUP
  _isStore   = $rootScope.isStore
  _loggedIn  = eeAuth.fns.hasToken()
  _loggedOut = !_loggedIn

  _exports =
    User:
      user:
        storefront_meta: eeBootstrap?.storefront_meta
    Collections:
      collections:  eeBootstrap?.collections
      nav:          eeBootstrap?.nav
    Products:         eeProducts.data
    Categorizations:  eeCategorizations.data
    meta:             {}
    carousel:         {}
    about:            {}
    loading:          {}

  _exports.Products.storefront =
    products:   eeBootstrap?.products
    page:       eeBootstrap?.page
    perPage:    eeBootstrap?.perPage
    count:      eeBootstrap?.count


  ## PRIVATE FUNCTIONS
  _resetData = () ->
    eeUser.data         = {}
    eeCollections.data  = {}
    eeProducts.data     = {}

  _collectionsArray = (collections) ->
    collections ||= {}
    array = []
    array.push c for c in Object.keys(collections)
    array

  _fillExportData = (user, data) ->
    _exports.user           = user
    _exports.meta           = user.storefront_meta
    _exports.carousel       = user.storefront_meta?.home?.carousel[0]
    _exports.about          = user.storefront_meta?.about
    _exports.template_ids   = data.template_ids
    _exports.categories     = data.categories
    _exports.logged_in      = eeAuth.fns.hasToken()

  _defineLoggedIn = () ->
    console.info '_defineLoggedIn'
    _exports.logged_in  = true
    _exports.loading    = true
    _exports.blocked    = false
    eeAuth.fns.defineUserFromToken()
    .catch (err) -> return # console.error err
    .finally  () -> _exports.loading = false

  _defineLanding = () ->
    console.info '_defineLanding'
    _exports.logged_in  = false
    _exports.loading    = false
    _exports.blocked    = true
    _resetData()

  ## DEFINITION LOGIC
  if _isBuilder and _loggedIn   then _defineLoggedIn()
  if _isBuilder and _loggedOut  then _defineLanding()

  $rootScope.$on 'definer:login',     () -> _defineLoggedIn()
  $rootScope.$on 'definer:logout',    () -> _defineLanding()

  ## EXPORTS
  exports: _exports

'use strict'

angular.module('store.core').factory 'eeCollection', ($rootScope, $q, $state, $stateParams, $location, eeBootstrap, eeBack) ->

  ## SETUP
  _inputDefaults =
    perPage:    eeBootstrap?.perPage
    page:       eeBootstrap?.page

  ## PRIVATE EXPORT DEFAULTS
  _data =
    reading:    false
    inputs:     angular.copy _inputDefaults
    count:      eeBootstrap?.count
    collection: eeBootstrap?.collection
    products:   eeBootstrap?.products

  ## PRIVATE FUNCTIONS
  _resetPage = () ->
    _data.inputs.page = null
    _data.inputs.category = parseInt $stateParams.id
    $stateParams.p = null
    $location.search 'p', null

  _formQuery = () ->
    query = {}
    if _data.inputs.page then query.page = _data.inputs.page
    query

  _defineCollection = (id, reset) ->
    _data.reading = true
    if reset then _data.collection = {}
    eeBack.fns.collectionGET id, _formQuery()
    .then (res) ->
      { collection, rows, count, page, perPage } = res
      # _data.inputs.page     = page
      # _data.inputs.perPage  = perPage
      # _data.count           = count
      _data.collection      = collection
      # _data.products        = rows
    .finally () -> _data.reading = false

  # MESSAGING
  $rootScope.$on 'reset:page', () -> _resetPage()

  ## EXPORTS
  data: _data
  fns:
    defineCollection: _defineCollection
    search: (id) ->
      _data.page = 1
      _defineCollection id, true

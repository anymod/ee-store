'use strict'

angular.module('store.core').factory 'eeCollection', ($rootScope, $q, eeBootstrap, eeBack) ->

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
      _data.page        = page
      _data.perPage     = perPage
      _data.count       = count
      _data.collection  = collection
      _data.products    = rows
    .finally () -> _data.reading = false

  ## EXPORTS
  data: _data
  fns:
    defineCollection: _defineCollection
    search: (id) ->
      _data.page = 1
      _defineCollection id, true

'use strict'

angular.module('store.core').factory 'eeCollections', (eeBootstrap, eeBack) ->

  ## SETUP
  _data =
    reading:      false
    nav:          eeBootstrap?.nav
    collections:  eeBootstrap?.collections
    # count:        eeBootstrap?.count

  ## PRIVATE FUNCTIONS
  _runQuery = () ->
    if _data.reading then return
    _data.reading = true
    eeBack.fns.collectionsGET()
    .then (res) ->
      { rows, count } = res
      _data.collections = rows
      # _data.count       = count
    .catch (err) -> _data.count = null
    .finally () -> _data.reading = false

  ## EXPORTS
  data: _data
  fns:
    search: _runQuery

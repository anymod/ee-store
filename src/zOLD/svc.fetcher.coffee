'use strict'

angular.module('store.core').factory 'eeFetcher', ($q, $state, eeBootstrap, eeBack) ->

  _data =
    loading: false

  _redefineBootstrap = (res) ->
    eeBootstrap.count       = res.count
    eeBootstrap.collections = res.collections
    eeBootstrap.selections  = res.selections

  _setFeatured    = () ->
    deferred = $q.defer()
    if !!eeBootstrap.loading then return eeBootstrap.loading
    eeBootstrap.loading = deferred.promise
    eeBack.fns.featuredGET eeBootstrap.username
    .then (data) ->
      _redefineBootstrap data
      deferred.resolve data
    .catch (err) -> deferred.reject err
    .finally () -> eeBootstrap.loading = false
    deferred.promise

  _setCollection  = (title) ->
    deferred = $q.defer()
    if !!eeBootstrap.loading then return eeBootstrap.loading
    eeBootstrap.loading = deferred.promise
    eeBack.fns.collectionGET eeBootstrap.username, title
    .then (data) ->
      _redefineBootstrap data
      deferred.resolve data
    .catch (err) -> deferred.reject err
    .finally () -> eeBootstrap.loading = false
    deferred.promise

  _setSelection   = (id) ->
    console.log '_setSelection', id
    _data.loading = true

  _fetch = () ->
    if $state.current.name is 'storefront'    then _setFeatured()
    if $state.current.name is 'collection'    then _setCollection $state.params.title
    if $state.current.name is 'selectionView' then _setSelection $state.params.id


  data: _data
  fns:
    fetch: _fetch

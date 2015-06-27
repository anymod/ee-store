'use strict'

angular.module('app.core').factory 'eeSelections', ($rootScope, $q, eeBack, eeAuth) ->

  ## SETUP
  _inputDefaults =
    perPage:  48
    page:             null
    search:           null
    searchLabel:      null
    collection:       null

  ## PRIVATE EXPORT DEFAULTS
  _data =
    count:      null
    selections: []
    inputs:     _inputDefaults
    searching:  false
    creating:   false
    updating:   false
    deleting:   false
    stale:      false

  ## PRIVATE FUNCTIONS
  _formQuery = () ->
    query = {}
    if _data.inputs.page        then query.page       = _data.inputs.page
    if _data.inputs.search      then query.search     = _data.inputs.search
    if _data.inputs.collection  then query.collection = _data.inputs.collection
    query

  _runQuery = () ->
    deferred = $q.defer()
    # if searching then avoid simultaneous calls to API
    if !!_data.searching then return _data.searching
    _data.searching = deferred.promise
    eeBack.selectionsGET eeAuth.fns.getToken(), _formQuery()
    .then (res) ->
      { count, rows }   = res
      _data.count       = count
      _data.selections  = rows
      _data.inputs.searchLabel = _data.inputs.search
      _fresh()
      deferred.resolve _data.selections
    .catch (err) ->
      _data.count = null
      deferred.reject err
    .finally () -> _data.searching = false
    deferred.promise

  _createSelection = (product) ->
    deferred = $q.defer()
    # if creating then avoid simultaneous calls to API
    if !!_data.creating then return _data.creating
    product.adding = true
    _data.creating = deferred.promise
    attrs =
      product_id: product.id
      collection: product.category
      margin: 15
    eeBack.selectionsPOST eeAuth.fns.getToken(), attrs
    .then (selection) ->
      _stale()
      _data.selection   = selection
      product.added_as  = selection.id
      deferred.resolve _data.selection
    .catch (err) -> deferred.reject err
    .finally () ->
      product.adding  = false
      _data.creating  = false
    deferred.promise

  _deleteSelection = (selection_id) ->
    deferred = $q.defer()
    # if deleting then avoid simultaneous calls to API
    if !!_data.deleting then return _data.deleting
    _data.deleting = deferred.promise
    eeBack.selectionsDELETE eeAuth.fns.getToken(), selection_id
    .then (selection) ->
      _stale()
      _data.selection = selection
      deferred.resolve _data.selection
    .catch (err) -> deferred.reject err
    .finally () -> _data.deleting = false
    deferred.promise

  _updateSelection = (selection) ->
    deferred = $q.defer()
    eeBack.selectionsPUT eeAuth.fns.getToken(), selection
    .then (sel) ->
      _stale()
      _data.selection = sel
      deferred.resolve _data.selection
    .catch (err) -> deferred.reject err
    deferred.promise

  _toggleFeatured = (selection) ->
    selection.updating = true
    selection.featured = !selection.featured
    _updateSelection selection
    .then (sel) -> selection.featured = sel.featured
    .finally () -> selection.updating = false

  _stale = () ->
    _data.stale = true
    $rootScope.$emit 'selections:stale'
    $rootScope.$emit 'user:stale'

  _fresh = () ->
    _data.stale = false
    $rootScope.$emit 'selections:fresh'

  ## EXPORTS
  data: _data
  fns:
    search: () ->
      _data.inputs.page = 1
      _runQuery()
    clearSearch: () ->
      _data.inputs.search = ''
      _data.inputs.page = 1
      _runQuery()
    incrementPage: () ->
      _data.inputs.page = if _data.inputs.page < 1 then 2 else _data.inputs.page + 1
      _runQuery()
    decrementPage: () ->
      _data.inputs.page = if _data.inputs.page < 2 then 1 else _data.inputs.page - 1
      _runQuery()
    setCollection: (collection) ->
      _data.inputs.page = 1
      _data.inputs.collection = if _data.inputs.collection is collection then null else collection
      _runQuery()
    createSelection: _createSelection
    deleteSelection: _deleteSelection
    updateSelection: _updateSelection
    toggleFeatured:  _toggleFeatured

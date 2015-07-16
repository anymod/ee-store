'use strict'

angular.module('app.core').factory 'eeSelection', ($rootScope, $cookies, $q, eeBack) ->

  ## SETUP
  _isBuilder          = $rootScope.isBuilder
  _isStore            = $rootScope.isStore
  _loggedIn           = !!$cookies.loginToken
  _loggedOut          = !_loggedIn

  _data = {}

  _reset = () ->
    _data.selection = {}
    # _data.calculated =
    #   selling_cents:    undefined
    #   selling_dollars:  undefined
    #   earnings:         undefined
    #   margin:           undefined
    # _data.margins =
    #   min_margin:       0.05
    #   max_margin:       0.80
    #   start_margin:     0.15
    #   margin_array:     [0.1, 0.2, 0.3]
    _data.collections = ['Featured']
    _data.loading   = false
    _data.deleting  = false

  if !_data.margins then _reset()

  _addSelection  = (selection) ->
    $rootScope.$broadcast 'selection:added', selection

  _removeSelection = (id) ->
    $rootScope.$broadcast 'selection:removed', id

  # _calculate = () ->
  #   if !_data.selection?.selling_price then return
  #   _data.calculated.selling_cents    = Math.abs(parseInt(_data.selection.selling_price % 100))
  #   _data.calculated.selling_dollars  = parseInt(parseInt(_data.selection.selling_price) - _data.calculated.selling_cents) / 100
  #   _data.calculated.earnings         = _data.selection.selling_price - _data.selection.baseline_price
  #   _data.calculated.margin           = 1 - (_data.selection.baseline_price / _data.selection.selling_price)
  #   return

  _setSelectionFromId = (id) ->
    deferred = $q.defer()
    _data.selection = {}
    if !!_data.loading then return _data.loading
    if !id then deferred.reject('Missing selection ID'); return deferred.promise
    _data.loading = deferred.promise
    eeBack.selectionGET id, $cookies.loginToken
    .then (sel) ->
      _data.selection = sel
      deferred.resolve sel
    .catch (err) -> deferred.reject err
    .finally () -> _data.loading = false
    deferred.promise

  # _setSelectionFromProduct = (product) ->
  #   _data.selection =
  #     product_id:     product.id
  #     title:          product.title
  #     content:        product.content
  #     collection:     product.category
  #     featured:       true
  #     margin:         _data.margins.start_margin
  #     baseline_price: parseInt(product.baseline_price)
  #     selling_price:  parseInt(product.baseline_price / (1 - _data.margins.start_margin))
  #   _calculate()

  _createSelection = (selection) ->
    deferred = $q.defer()
    if !$cookies.loginToken then deferred.reject 'Missing login credentials'; return deferred.promise
    _data.creating = deferred.promise
    eeBack.selectionsPOST $cookies.loginToken, selection
    .then (sel) ->
      _addSelection sel.id
      deferred.resolve sel
    .catch (err) -> deferred.reject err
    .finally () -> _data.creating = false
    deferred.promise

  _updateSelection = (selection) ->
    deferred = $q.defer()
    if !$cookies.loginToken then deferred.reject 'Missing login credentials'; return deferred.promise
    _data.loading = deferred.promise
    eeBack.selectionsPUT $cookies.loginToken, selection
    .then (sel) ->
      selection = sel
      deferred.resolve sel
    .catch (err) -> deferred.reject err
    .finally () -> _data.loading = false
    deferred.promise

  _deleteSelection = (id) ->
    deferred = $q.defer()
    if !$cookies.loginToken then deferred.reject 'Missing login credentials'; return deferred.promise
    _data.deleting = deferred.promise
    eeBack.selectionsDELETE $cookies.loginToken, id
    .then (data) ->
      _removeSelection id
      deferred.resolve data
    .catch (err) -> deferred.reject err
    .finally () -> _data.deleting = false
    deferred.promise

  data: _data
  fns:
    createSelection:    _createSelection
    updateSelection:    _updateSelection
    deleteSelection:    _deleteSelection
    setSelectionFromId: _setSelectionFromId
    # createSelectionFromProduct: (product) -> createSelection { product_id: product.id }

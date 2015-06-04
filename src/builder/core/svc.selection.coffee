'use strict'

angular.module('builder.core').factory 'eeSelection', ($rootScope, $cookies, $q, eeBack) ->

  _addSelection  = (selection) ->
    $rootScope.$broadcast 'selection:added', selection

  _removeSelection = (id) ->
    $rootScope.$broadcast 'selection:removed', id

  reset: () -> return

  createSelection: (product, margin) ->
    deferred = $q.defer()
    attrs =
      supplier_id: product.supplier_id
      product_id: product.id
      margin: margin
    if !$cookies.loginToken
      deferred.reject 'Missing login credentials'
    else
      eeBack.selectionsPOST($cookies.loginToken, attrs)
      .then (data) ->
        _addSelection data.id
        deferred.resolve data
      .catch (err) -> deferred.reject err
    deferred.promise

  deleteSelection: (id) ->
    deferred = $q.defer()
    if !$cookies.loginToken
      deferred.reject 'Missing login credentials'
    else
      eeBack.selectionsDELETE($cookies.loginToken, id)
      .then (data) ->
        _removeSelection id
        deferred.resolve data
      .catch (err) -> deferred.reject err
    deferred.promise

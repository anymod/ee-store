'use strict'

angular.module('store.core').factory 'eeBack', ($http, $q, eeBackUrl) ->

  _data =
    requesting: false
    requestingArray: []

  _handleError = (deferred, data, status) ->
    if status is 0 then deferred.reject 'Connection error' else deferred.reject data

  _setRequesting = () -> _data.requesting = _data.requestingArray.length > 0

  _startRequest = () ->
    _data.requestingArray.push 'r'
    _setRequesting()

  _endRequest = () ->
    _data.requestingArray.pop()
    _setRequesting()

  _makeRequest = (req) ->
    _startRequest()
    deferred = $q.defer()
    $http(req)
      .success (data, status) -> deferred.resolve data
      .error (data, status) -> _handleError deferred, data, status
      .finally () -> _endRequest()
    deferred.promise

  _formQueryString = (query) ->
    if !query then return ''
    keys = Object.keys(query)
    parts = []
    addQuery = (key) -> parts.push(encodeURIComponent(key) + '=' + encodeURIComponent(query[key]))
    addQuery(key) for key in keys
    '?' + parts.join('&')

  data: _data

  featuredGET: (username) ->
    if !username then throw 'Missing username'
    _makeRequest {
      method: 'GET'
      url: eeBackUrl + 'store/featured'
      headers: authorization: username
    }

  collectionGET: (username, collection) ->
    if !username then throw 'Missing username'
    if !collection then throw 'Missing collection'
    _makeRequest {
      method: 'GET'
      url: eeBackUrl + 'store/collections/' + collection
      headers: authorization: username
    }

  selectionGET: (username, selection_id) ->
    if !username then throw 'Missing username'
    if !id then throw 'Missing selection id'
    _makeRequest {
      method: 'GET'
      url: eeBackUrl + 'store/selections/' + selection_id
      headers: authorization: username
    }

  cartPOST: (quantity_array) ->
    _makeRequest {
      method: 'POST'
      url: eeBackUrl + 'carts'
      data: { quantity_array: quantity_array }
    }

  cartPUT: (cart_id, data) ->
    _makeRequest {
      method: 'PUT'
      url: eeBackUrl + 'carts/' + cart_id
      data: data
    }

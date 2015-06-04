'use strict'

angular.module('app.core').factory 'eeBack', ($http, $q, eeBackUrl) ->

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

  tokenPOST: (token) ->
    _makeRequest {
      method: 'POST'
      url: eeBackUrl + 'token'
      headers: authorization: token
    }

  authPOST: (email, password) ->
    _makeRequest {
      method: 'POST'
      url: eeBackUrl + 'auth'
      headers: authorization: 'Basic ' + email + ':' + password
    }

  goPOST: (token) ->
    _makeRequest {
      method: 'POST'
      url: eeBackUrl + 'go'
      data: { token: token }
    }

  passwordResetEmailPOST: (email) ->
    _makeRequest {
      method: 'POST'
      url: eeBackUrl + 'password_reset_email'
      headers: {}
      data: { email: email }
    }

  usersPUT: (user, token) ->
    _makeRequest {
      method: 'PUT'
      url: eeBackUrl + 'users'
      headers: authorization: token
      data: user
    }

  usersPOST: (email) ->
    _makeRequest {
      method: 'POST'
      url: eeBackUrl + 'users'
      headers: {}
      data:
        email: email
    }

  usersUpdatePasswordPUT: (password, token) ->
    _makeRequest {
      method: 'PUT'
      url: eeBackUrl + 'users_update_password'
      headers: authorization: token
      data: { password: password }
    }

  usersUpdateEmailPUT: (email, token) ->
    _makeRequest {
      method: 'PUT'
      url: eeBackUrl + 'users_update_email'
      headers: authorization: token
      data: { email: email }
    }

  usersCompletePUT: (data, token) ->
    _makeRequest {
      method: 'PUT'
      url: eeBackUrl + 'complete'
      headers: authorization: token
      data: data
    }

  usersStorefrontGET: (token) ->
    _makeRequest {
      method: 'GET'
      url: eeBackUrl + 'users/storefront'
      headers: authorization: token
    }

  productsGET: (token, query) ->
    _makeRequest {
      method: 'GET'
      url: eeBackUrl + 'products' + _formQueryString(query)
      headers: authorization: token
    }

  productGET: (id, token) ->
    _makeRequest {
      method: 'GET'
      url: eeBackUrl + 'products/' + id
      headers: authorization: token
    }

  selectionsPOST: (token, attrs) ->
    _makeRequest {
      method: 'POST'
      url: eeBackUrl + 'selections'
      headers: authorization: token
      data: attrs
    }

  selectionsPUT: (token, id, attrs) ->
    _makeRequest {
      method: 'PUT'
      url: eeBackUrl + 'selections/' + id
      headers: authorization: token
      data: attrs
    }

  selectionsDELETE: (token, id) ->
    _makeRequest {
      method: 'DELETE'
      url: eeBackUrl + 'selections/' + id
      headers: authorization: token
    }

  storefrontGET: (username) ->
    _makeRequest {
      method: 'GET'
      url: eeBackUrl + 'store/' + username + '/all'
      headers: authorization: {}
    }

  ordersGET: (token) ->
    _makeRequest {
      method: 'GET'
      url: eeBackUrl + 'orders'
      headers: authorization: token
    }

  contactPOST: (name, email, message) ->
    _makeRequest {
      method: 'POST'
      url: eeBackUrl + 'contact'
      data: { name: name, email: email, message: message }
    }

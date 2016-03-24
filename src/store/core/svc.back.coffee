'use strict'

angular.module('store.core').factory 'eeBack', ($http, $q, eeBackUrl, eeBootstrap) ->

  back = this

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


  _productGET = (id) ->
    _makeRequest {
      method: 'GET'
      url: eeBackUrl + 'store/' + eeBootstrap?.tr_uuid + '/products/' + id
    }

  data: _data
  fns:

    userGET: () ->
      _makeRequest {
        method: 'GET'
        url: eeBackUrl + 'store/' + eeBootstrap?.tr_uuid
      }

    productGET: _productGET

    productsGET: (query) ->
      _makeRequest {
        method: 'GET'
        url: eeBackUrl + 'store/' + eeBootstrap?.tr_uuid + '/products' + _formQueryString(query)
      }

    skuGET: (product_id, sku_id) ->
      _productGET product_id
      .then (product) ->
        sku = {}
        if !product.skus or product.skus.length < 1 then return sku
        (if s.id is sku_id then sku = s) for s in product.skus
        sku.product =
          id: product.id
          image: product.image
          title: product.title
        sku

    collectionGET: (id, query) ->
      _makeRequest {
        method: 'GET'
        url: eeBackUrl + 'store/' + eeBootstrap?.tr_uuid + '/collections/' + id + _formQueryString(query)
      }

    collectionsGET: () ->
      _makeRequest {
        method: 'GET'
        url: eeBackUrl + 'store/' + eeBootstrap?.tr_uuid + '/collections'
      }

    cartPOST: (quantity_array) ->
      _makeRequest {
        method: 'POST'
        url: eeBackUrl + 'carts'
        data:
          quantity_array: quantity_array
          seller_id: eeBootstrap?.id
          domain: eeBootstrap?.url
      }

    cartGET: (cart_id) ->
      _makeRequest {
        method: 'GET'
        url: eeBackUrl + 'carts/' + cart_id + '?u=' + eeBootstrap?.id
      }

    cartPUT: (cart_id, data) ->
      _makeRequest {
        method: 'PUT'
        url: eeBackUrl + 'carts/' + cart_id
        data: data
      }

    customerPOST: (email) ->
      _makeRequest {
        method: 'POST'
        url: eeBackUrl + 'customers'
        data:
          email: email
          seller_id: eeBootstrap?.id
      }

    contactPOST: (name, email, message) ->
      _makeRequest {
        method: 'POST'
        url: eeBackUrl + 'contact'
        data: { name: name, email: email, message: message }
      }

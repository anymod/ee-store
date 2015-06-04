'use strict'

angular.module('builder.core').factory 'eeOrders', ($cookies, $q, eeBack, $http) ->
  _orders = []

  _setOrders  = (order_array) -> _orders = order_array
  _ordersIsEmpty = () -> (Object.keys(_orders).length is 0)

  dummyOrder = (storefront) ->
    if storefront?.product_selection?.length > 0
      orders = []
      createOrder = (product) ->
        order =
          shipmentStatus: 'pending'
          number: parseInt(Math.random() * 1000)
          title: product.title
          sellerPrice: product.selling_price
          sellerMargin: 0.15
          baselinePrice: (product.selling_price * (1 - 0.15))
          disbursementStatus: 'pending'
          product_snapshot: image_meta: main_image: url: product.image_meta.main_image.url
        orders.push order
      createOrder(product) for product in storefront.product_selection
      orders

  reset: () -> return

  # getOrders: () ->
  #   # _orders
  #   deferred = $q.defer()
  #   $http.get '/orders.json'
  #     .success (data) -> deferred.resolve data;
  #     .error (data) -> deferred.resolve data;
  #   deferred.promise

  getOrders: (opts) ->
    deferred = $q.defer()
    deferred.resolve dummyOrder opts?.storefront
    # if !$cookies.loginToken
    #   deferred.reject 'Missing login credentials'
    # else if !!_orders and !_ordersIsEmpty() and opts?.force isnt true
    #   deferred.resolve _orders
    # else
    #   eeBack.ordersGET($cookies.loginToken)
    #   .then (data) ->
    #     _setOrders data
    #     deferred.resolve data
    #   .catch (err) -> deferred.reject err
    deferred.promise

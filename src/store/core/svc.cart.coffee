'use strict'

angular.module('store.core').factory 'eeCart', ($rootScope, $state, $cookies, eeBootstrap, eeBack) ->

  ## SETUP
  # none

  ## PRIVATE EXPORT DEFAULTS
  _data =
    creating: false
    reading:  false
    updating: false
    cart:
      skus: eeBootstrap?.cart?.skus
      quantity_array: eeBootstrap?.cart?.quantity_array

  ## PRIVATE FUNCTIONS
  _defineCart = () -> return

  _addOrIncrement = (sku_id) ->
    inArray = false
    for pair, i in _data.cart.quantity_array
      if parseInt(sku_id) is parseInt(pair.sku_id)
        pair.quantity += 1
        inArray = true
    _data.cart.quantity_array.push { sku_id: sku_id, quantity: 1 } unless inArray
    _data.cart.quantity_array

  _addSku = (sku_id) ->
    _addOrIncrement sku_id
    if $cookies.get('cart')
      [ee, cart_id, token] = $cookies.get('cart').split('.')
      eeBack.fns.cartPUT cart_id, { quantity_array: _data.cart.quantity_array, token: token }
      .then (res) ->
        $cookies.put 'cart', ['ee', res.id, res.uuid].join('.')
        $state.go 'cart'
      .catch (err) -> console.error err
    else
      eeBack.fns.cartPOST _data.cart.quantity_array
      .then (res) ->
        $cookies.put 'cart', ['ee', res.id, res.uuid].join('.')
        $state.go 'cart'
      .catch (err) -> console.error err

  _removeSku = (sku_id) ->
    temp = []
    for pair, i in _data.cart.quantity_array
      if parseInt(sku_id) isnt parseInt(pair.sku_id) then temp.push _data.cart.quantity_array[i]
    _data.cart.quantity_array = temp
    [ee, cart_id, token] = $cookies.get('cart').split('.')
    eeBack.fns.cartPUT cart_id, { quantity_array: _data.cart.quantity_array, token: token }
    .then (res) ->
      $cookies.put 'cart', ['ee', res.id, res.uuid].join('.')
      $state.go 'cart', null, reload: true
    .catch (err) -> console.error err

  _updateCartTo = (quantity_array) ->
    quantity_array ||= []
    [ee, cart_id, token] = $cookies.get('cart').split('.')
    eeBack.fns.cartPUT cart_id, { quantity_array: quantity_array, token: token }
    .then (res) ->
      _data.cart.quantity_array = res.quantity_array
      $cookies.put 'cart', ['ee', res.id, res.uuid].join('.')
      $state.go 'cart', null, reload: true
    .catch (err) -> console.error err


  ## EXPORTS
  data: _data
  fns:
    addSku:       _addSku
    removeSku:    _removeSku
    updateCartTo: _updateCartTo

'use strict'

angular.module('store.core').factory 'eeCart', ($rootScope, $state, $cookies, eeBack) ->

  _addOrIncrement = (selection_id, quantity_array) ->
    quantity_array ||= []
    inArray = false
    for pair, i in quantity_array
      if parseInt(selection_id) is parseInt(pair.id)
        pair.quantity += 1
        inArray = true
    quantity_array.push { id: selection_id, quantity: 1 } unless inArray
    quantity_array

  _remove = (selection_id, quantity_array) ->
    quantity_array ||= []
    temp = []
    for pair, i in quantity_array
      if parseInt(selection_id) isnt parseInt(pair.id) then temp.push quantity_array[i]
    temp

  _addSelection = (selection_id, quantity_array) ->
    quantity_array = _addOrIncrement selection_id, quantity_array
    if $cookies.cart
      [ee, cart_id, token] = $cookies.cart.split('.')
      eeBack.cartPUT cart_id, { quantity_array: quantity_array, token: token }
      .then (res) ->
        $cookies.cart = ['ee', res.id, res.uuid].join('.')
        $state.go 'cart'
      .catch (err) -> console.error err
    else
      eeBack.cartPOST quantity_array
      .then (res) ->
        $cookies.cart = ['ee', res.id, res.uuid].join('.')
        $state.go 'cart'
      .catch (err) -> console.error err

  _removeSelection = (selection_id, quantity_array) ->
    quantity_array = _remove selection_id, quantity_array
    [ee, cart_id, token] = $cookies.cart.split('.')
    eeBack.cartPUT cart_id, { quantity_array: quantity_array, token: token }
    .then (res) ->
      $cookies.cart = ['ee', res.id, res.uuid].join('.')
      $state.go 'cart', null, reload: true
    .catch (err) -> console.error err

  _updateCartTo = (quantity_array) ->
    quantity_array ||= []
    [ee, cart_id, token] = $cookies.cart.split('.')
    eeBack.cartPUT cart_id, { quantity_array: quantity_array, token: token }
    .then (res) ->
      $cookies.cart = ['ee', res.id, res.uuid].join('.')
      $state.go 'cart', null, reload: true
    .catch (err) -> console.error err


  ## EXPORTS
  fns:
    addSelection: _addSelection
    removeSelection: _removeSelection
    updateCartTo: _updateCartTo

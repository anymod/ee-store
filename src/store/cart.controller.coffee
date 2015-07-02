'use strict'

angular.module('eeStore').controller 'cartCtrl', ($scope, $location, $cookies, eeBootstrap, eeCart) ->

  # TODO implement cart_quantity for PayPal

  cart = this

  # Define data
  cart.selections     = eeBootstrap?.cart?.selections || []
  cart.quantity_array = eeBootstrap?.cart?.quantity_array || []

  _syncArrays = () ->
    synced = []
    for pair in cart.quantity_array
      for selection in cart.selections
        synced.push selection if parseInt(selection.id) is parseInt(pair.id)
    cart.selections = synced
  _syncArrays()

  # Set lookup object
  selection_lookup = {}
  selection_lookup[selection.id] = selection for selection in cart.selections

  # Calculate selling_price_sum
  cart.selling_price_sum = 0
  cart.selling_price_sum += (parseInt(pair.quantity) * parseInt(selection_lookup[parseInt(pair.id)].selling_price)) for pair in cart.quantity_array

  # Calculate shipping_price_sum
  cart.shipping_price_sum = 0
  cart.shipping_price_sum += (parseInt(pair.quantity) * parseInt(selection_lookup[parseInt(pair.id)].product_meta.shipping_price)) for pair in cart.quantity_array

  # Calculate totals
  cart.subtotal = cart.selling_price_sum + cart.shipping_price_sum
  cart.taxes    = 0
  cart.total    = cart.subtotal + cart.taxes

  # Other PayPal variables
  cart.item_name      = if cart.quantity_array.length > 1 then ('' + cart.quantity_array.length + ' items') else cart.selections[0]?.title
  cart.item_number    = $cookies.cart?.split('.')[1]
  cart.return         = '' + $location.absUrl() + '/success'
  cart.cancel_return  = '' + $location.absUrl()

  # Cart operations
  n = 0
  $scope.$watch 'cart.quantity_array', (newVal, oldVal) ->
    if n is 0 then return n = 1
    eeCart.fns.updateCartTo newVal
  , true

  cart.removeSelection = (id) -> eeCart.fns.removeSelection id, cart.quantity_array

  return

'use strict'

angular.module('eeStore').controller 'cartCtrl', ($scope, $window, $location, $cookies, eeBootstrap, eeDefiner, eeSecureUrl, eeCart) ->

  cart = this

  cart.ee = eeDefiner.exports
  cart.skus = cart.ee.Cart?.cart?.skus || []
  cart.quantity_array = cart.ee.Cart?.cart?.quantity_array || []

  ###### OLD

  # Define data
  # cart.skus = eeBootstrap?.cart?.skus || []
  # cart.quantity_array = eeBootstrap?.cart?.quantity_array || []

  _syncArrays = () ->
    synced = []
    for pair in cart.quantity_array
      for sku in cart.skus
        synced.push sku if parseInt(sku.id) is parseInt(pair.sku_id)
    cart.skus = synced
  _syncArrays()

  # Set lookup object
  sku_lookup = {}
  sku_lookup[sku.id] = sku for sku in cart.skus

  # Calculate cumulative_price
  cart.cumulative_price = 0
  cart.cumulative_price += (parseInt(pair.quantity) * parseInt(sku_lookup[parseInt(pair.sku_id)]?.price)) for pair in cart.quantity_array

  # Calculate shipping_total
  cart.shipping_total = 0
  cart.shipping_total += (parseInt(pair.quantity) * parseInt(sku_lookup[parseInt(pair.sku_id)]?.shipping_price || 0)) for pair in cart.quantity_array

  # Calculate totals
  cart.subtotal     = cart.cumulative_price + cart.shipping_total
  cart.taxes_total  = 0
  cart.grand_total  = cart.subtotal + cart.taxes_total

  # Other PayPal variables
  cart.quantity       = 0
  cart.quantity      += pair.quantity for pair in cart.quantity_array
  cart.item_name      = if cart.quantity_array.length > 1 then ('' + cart.quantity_array.length + ' items (qty: ' + cart.quantity + ')') else cart.skus[0]?.title
  cart.item_number    = $cookies.get('cart')?.split('.')[1]
  cart.return         = '' + $location.absUrl() + '/success'
  cart.cancel_return  = '' + $location.absUrl()

  # Cart operations
  n = 0
  $scope.$watch 'cart.quantity_array', (newVal, oldVal) ->
    if n is 0 then return n = 1
    eeCart.fns.updateCartTo newVal
  , true

  cart.removeSku = (sku_id) -> eeCart.fns.removeSku sku_id

  cart.buy = () ->
    cart.processing = true
    $window.location.assign(eeSecureUrl + 'checkout/' + $cookies.get('cart')?.split('.')[2])

  return

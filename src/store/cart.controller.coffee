'use strict'

angular.module('eeStore').controller 'cartCtrl', ($scope, $window, $location, $cookies, eeBootstrap, eeSecureUrl, eeCart) ->

  cart = this

  # Define data
  cart.products  = eeBootstrap?.cart?.products || []
  cart.quantity_array = eeBootstrap?.cart?.quantity_array || []

  _syncArrays = () ->
    synced = []
    for pair in cart.quantity_array
      for product in cart.products
        synced.push product if parseInt(product.id) is parseInt(pair.id)
    cart.products = synced
  _syncArrays()

  # Set lookup object
  product_lookup = {}
  product_lookup[product.id] = product for product in cart.products

  # Calculate selling_price_sum
  cart.selling_price_sum = 0
  cart.selling_price_sum += (parseInt(pair.quantity) * parseInt(product_lookup[parseInt(pair.id)]?.selling_price)) for pair in cart.quantity_array

  # Calculate shipping_price_sum
  cart.shipping_price_sum = 0
  cart.shipping_price_sum += (parseInt(pair.quantity) * parseInt(product_lookup[parseInt(pair.id)]?.shipping_price || 0)) for pair in cart.quantity_array

  # Calculate totals
  cart.subtotal = cart.selling_price_sum + cart.shipping_price_sum
  cart.taxes    = 0
  cart.total    = cart.subtotal + cart.taxes

  # Other PayPal variables
  cart.quantity       = 0
  cart.quantity += pair.quantity for pair in cart.quantity_array
  cart.item_name      = if cart.quantity_array.length > 1 then ('' + cart.quantity_array.length + ' items (qty: ' + cart.quantity + ')') else cart.products[0]?.title
  cart.item_number    = $cookies.cart?.split('.')[1]
  cart.return         = '' + $location.absUrl() + '/success'
  cart.cancel_return  = '' + $location.absUrl()

  # Cart operations
  n = 0
  $scope.$watch 'cart.quantity_array', (newVal, oldVal) ->
    if n is 0 then return n = 1
    eeCart.fns.updateCartTo newVal
  , true

  cart.removeProduct = (id) -> eeCart.fns.removeProduct id, cart.quantity_array

  cart.buy = () ->
    cart.processing = true
    $window.location.assign(eeSecureUrl + 'checkout/' + $cookies.cart?.split('.')[2])

  return

'use strict'

angular.module('builder.core').factory 'eeCart', ($rootScope) ->

  ## SETUP
  _cart =
    calc_meta: {}
    entries: []

  ## PRIVATE FUNCTIONS
  _calcMeta = (cart) ->
    count           = 0
    product_total   = 0
    shipping_total  = 0
    tax_total       = 0
    grand_total     = 0
    addToTotals = (entry) ->
      product_total   += parseInt(parseInt(entry.product.selling_price) * parseInt(entry.quantity))
      shipping_total  += parseInt(parseInt(entry.product.shipping_price) * parseInt(entry.quantity))
      count           += parseInt(entry.quantity)
    addToTotals(cart_entry) for cart_entry in cart.entries
    grand_total = product_total + shipping_total + tax_total
    cart.calc_meta =
      count:          count
      product_total:  product_total
      shipping_total: shipping_total
      tax_total:      tax_total
      grand_total:    grand_total
    $rootScope.$broadcast 'cart:updated', _cart
    return

  ## EXPORTS
  count: () -> 0
  products: () -> []

  addProduct: (product) ->
    increment = false
    addOrIncrement = (selection_id, entry) ->
      if !!selection_id && entry.product.selection_id is selection_id
        entry.quantity += 1
        increment = true
    addOrIncrement(product.selection_id, entry) for entry in _cart.entries
    if increment is false then _cart.entries.push { product: product, quantity: 1 }
    _calcMeta _cart
    return

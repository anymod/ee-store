'use strict'

angular.module('store.core').factory 'eeCart', ($rootScope, $state, $cookies, eeBootstrap, eeBack) ->

  ## SETUP
  _summary =
    cumulative_price: 0
    shipping_total:   0
    subtotal:         0
    taxes_total:      0
    grand_total:      0

  ## PRIVATE EXPORT DEFAULTS
  _data =
    reading:  false
    updating: false
    quantity_array: eeBootstrap?.cart?.quantity_array || []
    skus: eeBootstrap?.cart?.skus || []
    summary: _summary

  ## PRIVATE FUNCTIONS
  _defineCart = () ->
    return if !$cookies.get('cart')
    _data.reading = true
    [ee, cart_id, token] = $cookies.get('cart')?.split('.')
    eeBack.fns.cartGET cart_id
    .then (cart) ->
      _data.quantity_array = cart.quantity_array
      _defineSummary()
      _syncSkus()
    .finally () -> _data.reading = false

  _getSku = (pair) ->
    _data.updating = true
    eeBack.fns.skuGET pair.product_id, pair.sku_id
    .then (fullSku) ->
      delete fullSku[attr] for attr in ['baseline_price']
      fullSku
    .finally () ->
      _defineSummary()
      _data.updating = false

  _addDataSku = (pair) ->
    _getSku pair
    .then (fullSku) ->
      _data.skus.push fullSku
      _defineSummary()

  _syncSku = (pair, sku) ->
    _getSku pair
    .then (fullSku) ->
      sku[attr] = fullSku[attr] for attr in Object.keys(fullSku)
      _defineSummary()

  _syncSkus = () ->
    for pair in _data.quantity_array
      matchSku = undefined
      for sku in _data.skus
        if sku.id is pair.sku_id then matchSku = sku
      if !matchSku
        _addDataSku pair
      else if !matchSku.price?
        _syncSku pair, matchSku
      console.log pair, matchSku,

      # matchingSku = undefined
      # for sku in _data.skus
      #   if sku.id is pair.sku_id then matchingSku = sku
      # if !matchingSku and matchingSku.price
      #   _data.updating = true
      #   eeBack.fns.skuGET pair.product_id, pair.sku_id
      #   .then (fullSku) ->
      #     delete fullSku.baseline_price
      #     # for sku in _data.skus
      #     #   if sku.id is fullSku.id
      #     matchingSku[attr] = fullSku[attr] for attr in Object.keys(fullSku)
      #     if unmatched then _data.skus.push fullSku
      #   .finally () ->
      #     _defineSummary()
      #     _data.updating = false

  _defineSummary = () ->
    # Set lookup object
    sku_lookup = {}
    sku_lookup[sku.id] = sku for sku in _data.skus

    # Calculate cumulative_price
    _data.summary.cumulative_price = 0
    _data.summary.cumulative_price += (parseInt(pair.quantity) * parseInt(sku_lookup[parseInt(pair.sku_id)]?.price)) for pair in _data.quantity_array

    # Calculate shipping_total
    _data.summary.shipping_total = 0
    # For Free shipping over $50
    if _data.summary.cumulative_price < 5000
      _data.summary.free_shipping = false
      _data.summary.shipping_total += (parseInt(pair.quantity) * parseInt(sku_lookup[parseInt(pair.sku_id)]?.shipping_price || 0)) for pair in _data.quantity_array
    else
      _data.summary.free_shipping = true

    # Calculate totals
    _data.summary.subtotal    = _data.summary.cumulative_price + _data.summary.shipping_total
    _data.summary.taxes_total = 0
    _data.summary.grand_total = _data.summary.subtotal + _data.summary.taxes_total
    return

  _defineSummary()

  _addOrIncrement = (sku) ->
    inArray = false
    for pair, i in _data.quantity_array
      if parseInt(sku.id) is parseInt(pair.sku_id)
        pair.quantity += 1
        inArray = true
        break
    _data.quantity_array.push { sku_id: sku.id, product_id: sku.product_id, quantity: 1 } unless inArray

  _createOrUpdate = () ->
    # Update
    if $cookies.get('cart')
      _data.updating = true
      [ee, cart_id, token] = $cookies.get('cart').split('.')
      eeBack.fns.cartPUT cart_id, { quantity_array: _data.quantity_array, token: token }
      .then (res) ->
        $cookies.put 'cart', ['ee', res.id, res.uuid].join('.')
        $state.go 'cart', null, reload: true
      .catch (err) -> console.error err
      .finally () -> _data.updating = false
    # Create
    else
      _data.updating = true
      eeBack.fns.cartPOST _data.quantity_array
      .then (res) ->
        $cookies.put 'cart', ['ee', res.id, res.uuid].join('.')
        $state.go 'cart', null, reload: true
      .catch (err) -> console.error err
      .finally () -> _data.updating = false

  _addSku = (sku) ->
    _addOrIncrement sku
    _createOrUpdate()

  _removeSku = (sku_id) ->
    tempQA = []
    for pair in _data.quantity_array
      if parseInt(sku_id) isnt parseInt(pair.sku_id) then tempQA.push pair
    _data.quantity_array = tempQA
    tempSkus = []
    for sku in _data.skus
      if parseInt(sku_id) isnt parseInt(sku.id) then tempSkus.push sku
    _data.skus = tempSkus
    _createOrUpdate()

  # _updateCartTo = (quantity_array) ->
  #   quantity_array ||= []
  #   [ee, cart_id, token] = $cookies.get('cart').split('.')
  #   eeBack.fns.cartPUT cart_id, { quantity_array: quantity_array, token: token }
  #   .then (res) ->
  #     _data.quantity_array = res.quantity_array
  #     $cookies.put 'cart', ['ee', res.id, res.uuid].join('.')
  #     $state.go 'cart', null, reload: true
  #   .catch (err) -> console.error err

  # n = 0
  # $rootScope.$watch '_data.quantity_array', (newVal, oldVal) ->
  #   if n is 0 then return n = 1
  #   _update()
  # , true

  ## MESSAGING
  $rootScope.$on 'cart:add:sku', (e, sku) -> _addSku sku

  ## EXPORTS
  data: _data
  fns:
    removeSku:    _removeSku
    defineCart:   _defineCart
    createOrUpdate: _createOrUpdate

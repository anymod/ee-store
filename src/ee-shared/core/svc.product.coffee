'use strict'

angular.module('app.core').factory 'eeProduct', ($q, $timeout, eeAuth, eeBack, eeStorefront, eeModal) ->

  ## SETUP
  # none

  ## PRIVATE EXPORT DEFAULTS
  _focused_product  = {}
  _focused_image    = {}

  _data = {}

  _reset = () ->
    _data.product =     {}
    _data.margins =
      min_margin:       0.05
      max_margin:       0.40
      start_margin:     0.15
      margin_array:     [0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4]
    _data.calculated =
      margin:           undefined
      selling_price:    undefined
      selling_dollars:  undefined
      selling_cents:    undefined
      earnings:         undefined
    _data.loading =     false

  _reset()

  ## PRIVATE FUNCTIONS
  _getProduct = (id) ->
    deferred = $q.defer()
    if !!_data.loading then return _data.loading
    if !id then deferred.reject('Missing product ID'); return deferred.promise
    _data.loading = deferred.promise
    eeBack.productGET id, eeAuth.fns.getToken()
    .then (data) -> deferred.resolve data
    .catch (err) -> deferred.reject err
    .finally () -> _data.loading = false
    deferred.promise

  _setProduct = (id) ->
    _data.product = {}
    _getProduct id
    .then (data) ->
      _data.product = data
      _calcByMargin _data.margins.start_margin
      console.log 'setProduct', _data
    .catch (err) -> _data.product = {}

  _calcPrice  = (base, margin)  -> parseInt(base / (1 - margin))
  _calcMargin = (base, selling) -> 1 - (base / selling)

  _calcByMargin = (margin) ->
    if margin < _data.margins.min_margin then return _calcByMargin _data.margins.min_margin
    if margin > _data.margins.max_margin then return _calcByMargin _data.margins.max_margin
    selling_price = _calcPrice _data.product.baseline_price, margin
    selling_cents = selling_price % 100
    _data.calculated.margin           = margin
    _data.calculated.selling_price    = selling_price
    _data.calculated.selling_cents    = selling_cents
    _data.calculated.selling_dollars  = parseInt((selling_price - selling_cents)/100)
    _data.calculated.earnings         = selling_price - _data.product.baseline_price
    _data.product.calculated          = _data.calculated
    return

  _calcByDollarsAndCents = () ->
    if !_data.calculated.selling_dollars or !_data.calculated.selling_cents then return
    selling_dollars = Math.abs(parseInt(_data.calculated.selling_dollars)*100)
    selling_cents   = Math.abs(parseInt(_data.calculated.selling_cents))
    if selling_cents > 99 then selling_cents = 99
    selling_price   = selling_dollars + selling_cents
    margin          = _calcMargin parseInt(_data.product.baseline_price), selling_price
    _calcByMargin margin
    return

  _openProductModal = (id, catalog) ->
    if !id then return
    _reset()
    _getProduct id
    .then (product) ->
      p_s = eeStorefront.fns.getProductSelection product
      margin = if !!p_s then _calcMargin(product.baseline_price, p_s.selling_price) else _data.margins.start_margin
      _data.product = product
      _calcByMargin margin
      if catalog then eeModal.fns.openCatalogProductModal() else eeModal.fns.openProductModal()
    .catch (err) -> console.error err

  ## EXPORTS
  focused_product:  _focused_product
  focused_image:    _focused_image
  data:             _data
  fns:
    reset: () ->            _reset()
    calcByMargin:           _calcByMargin
    calcByDollarsAndCents:  _calcByDollarsAndCents
    openProductModal:       _openProductModal
    setProduct:             _setProduct

'use strict'

angular.module('store.core').factory 'eeProduct', (eeBootstrap, eeBack) ->

  ## SETUP
  # none

  ## PRIVATE EXPORT DEFAULTS
  _data =
    reading:  false
    product:  eeBootstrap?.product

  ## PRIVATE FUNCTIONS
  _defineProduct = (id) ->
    _data.reading = true
    _data.product = {}
    eeBack.fns.productGET id
    .then (prod) -> _data.product = prod
    .finally () -> _data.reading = false

  ## MESSAGING
  # none

  ## EXPORTS
  data: _data
  fns:
    defineProduct: _defineProduct

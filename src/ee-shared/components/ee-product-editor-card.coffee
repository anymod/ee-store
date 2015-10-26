'use strict'

module = angular.module 'ee-product-editor-card', []

module.directive "eeProductEditorCard", ($window, eeCollection, eeCollections, eeProducts) ->
  templateUrl: 'ee-shared/components/ee-product-editor-card.html'
  restrict: 'E'
  scope:
    product:    '='
    collection: '='
    expanded:   '@'
  link: (scope, ele, attrs) ->
    scope.save_status = 'Save'
    scope.saved       = true
    scope.expanded  ||= false

    scope.calculated =
      max_price:          undefined
      min_price:          undefined
      selling_cents:      undefined
      selling_dollars:    undefined
      earnings:           undefined
      margin:             undefined
    scope.margins =
      min_margin:         0.05
      max_margin:         0.80
      start_margin:       0.15
      margin_array:       [0.1, 0.2, 0.3, 0.5]

    _setMaxAndMinPrice = () ->
      if !scope.product then return
      scope.calculated.max_price = Math.floor(scope.product.baseline_price / (1 - scope.margins.max_margin))
      scope.calculated.min_price = Math.ceil(scope.product.baseline_price / (1 - scope.margins.min_margin))

    _setDollarsAndCents = () ->
      if !scope.product?.selling_price then return
      scope.calculated.selling_cents    = Math.abs(parseInt(scope.product.selling_price % 100))
      scope.calculated.selling_dollars  = parseInt(parseInt(scope.product.selling_price) - scope.calculated.selling_cents) / 100
      return

    _setEarningsAndMargin = () ->
      if !scope.product then return
      scope.calculated.earnings     = scope.product.selling_price - scope.product.baseline_price
      scope.calculated.margin       = 1 - (scope.product.baseline_price / scope.product.selling_price)
      if scope.product.msrp then scope.calculated.msrpDiscount = (scope.product.msrp - scope.product.selling_price) / scope.product.msrp
      return

    _calculate = () ->
      _setMaxAndMinPrice()
      _setDollarsAndCents()
      _setEarningsAndMargin()
      return

    _calcByDollarsAndCents = () ->
      if !scope.calculated.selling_dollars or !scope.calculated.selling_cents then return
      selling_dollars = Math.abs(parseInt(scope.calculated.selling_dollars)*100)
      selling_cents   = Math.abs(parseInt(scope.calculated.selling_cents))
      if selling_cents > 99 then selling_cents = 99
      scope.product.selling_price = selling_dollars + selling_cents
      _calculate()
      return

    scope.setSellingPrice = (price) ->
      scope.product.selling_price = price
      _calculate()

    scope.calcByMargin = (margin) ->
      if !margin then return
      scope.product.selling_price = parseInt(scope.product.baseline_price / (1 - margin))
      _calculate()
      return

    _setDollarsAndCents()
    _setMaxAndMinPrice()
    _setEarningsAndMargin()

    scope.$watchGroup ['calculated.selling_dollars', 'calculated.selling_cents'], (newVal, oldVal) ->
      if oldVal then _calcByDollarsAndCents()
      return

    scope.updateProduct = () ->
      scope.save_status = 'Saving'
      eeProducts.fns.updateProduct scope.product
      .then () ->
        scope.save_status = 'Save'
        scope.expanded    = false
        scope.saved       = true
      .catch (err) -> scope.save_status = 'Problem saving'

    scope.removeProduct = () ->
      if scope.collection and scope.collection.id
        removeProduct = $window.confirm 'Remove this from your collection?'
        if removeProduct
          scope.save_status = 'Removing'
          eeCollections.fns.removeTemplate scope.collection.id, scope.product
          .catch (err) -> scope.save_status = 'Problem removing'
      else
        deleteProduct = $window.confirm 'Remove this from your store?'
        if deleteProduct
          scope.save_status = 'Removing'
          eeProducts.fns.destroyProduct scope.product
          .then () -> scope.product.removed = true
          .catch (err) -> scope.save_status = 'Problem removing'

    scope.feature = () ->
      scope.product.featured = true
      scope.updateProduct()

    scope.unfeature = () ->
      scope.product.featured = false
      scope.updateProduct()

    scope.expand = () ->
      scope.expanded = true
      n = 0
      scope.$watch () ->
        return scope.product
      , (newVal, oldVal) ->
        if oldVal and oldVal.id and n > 0 then scope.saved = false
        if n is 0 then n += 1
      , true

    return

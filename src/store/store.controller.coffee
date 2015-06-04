'use strict'

angular.module('eeStore').controller 'storeCtrl', ($rootScope, eeDefiner) ->
  this.ee = eeDefiner.exports
  that = this
  $rootScope.storeName  = 'Loading'

  # eeStorefront.fns.getStorefront()
  # .then (storefront) ->
  #   ## For loading
  #   $rootScope.storeName    = storefront.storefront_meta?.home?.name
  #
  #   ## For shared views (carousel, products, about, footer)
  #   that.meta               = storefront.storefront_meta
  #   that.carousel           = storefront.storefront_meta?.home?.carousel[0]
  #   that.about              = storefront.storefront_meta?.about
  #   that.product_selection  = storefront.product_selection
  #   that.categories         = eeStorefront.data.categories
  #
  # .catch () -> $rootScope.storeName = 'Not found'
  # .finally () -> that.loading = false

  return

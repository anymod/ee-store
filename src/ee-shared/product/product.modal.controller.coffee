'use strict'

angular.module('app.core').controller 'productModalCtrl', ($rootScope, eeDefiner, eeModal, eeProduct, eeStorefront, eeCart) ->

  that = this

  this.ee           = eeDefiner.exports
  this.data         = eeProduct.data
  this.product      = eeProduct.data.product
  this.fns          = eeProduct.fns
  this.mainImage    = this.data.product?.image_meta?.main_image
  this.inStorefront = eeStorefront.fns.inStorefront
  this.showPriceOptions = false

  this.addProduct   = () ->
    if that.ee.logged_in then eeStorefront.fns.addProduct(that.product) else eeStorefront.fns.addDummyProduct(that.product)
    eeModal.fns.close 'product'

  this.removeProductSelection = () ->
    index = eeStorefront.data.product_ids.indexOf that.product.id
    if index > -1
      p_s = that.ee.product_selection[index]
      if that.ee.logged_in then eeStorefront.fns.removeProductSelection(p_s) else eeStorefront.fns.removeDummyProductSelection(p_s)

  this.addProductToCart = () ->
    if $rootScope.isBuilder then that.showAddPopover = true
    if $rootScope.isStore   then eeCart.addProduct that.product

  this.setMainImage = (img) -> that.mainImage = img

  this.updatePricing = () ->
    eeProduct.fns.calcByDollarsAndCents()
    index = eeStorefront.data.product_ids.indexOf that.product.id
    if index > -1
      p_s = that.ee.product_selection[index]
      if that.ee.logged_in then eeStorefront.fns.updateProductSelection(p_s, that.product) else eeStorefront.fns.updateDummyProductSelection(p_s, that.product)
    that.showPriceOptions = false

  return

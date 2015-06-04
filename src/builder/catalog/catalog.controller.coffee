'use strict'

angular.module('builder.catalog').controller 'catalogCtrl', (eeModal, eeDefiner, eeLanding, eeProduct, eeStorefront, eeCatalog) ->

  this.ee = eeDefiner.exports

  this.data       = eeCatalog.data
  this.fns        = eeCatalog.fns
  this.productFns = eeProduct.fns
  this.storeFns   = eeStorefront.fns
  this.feedback   = () -> eeModal.fns.open 'feedback'

  # if !this.ee.logged_in
  #   this.show         = eeLanding.show
  #   this.landingData  = eeLanding.data
  #   this.landingFns   = eeLanding.fns

  eeCatalog.fns.search()

  return

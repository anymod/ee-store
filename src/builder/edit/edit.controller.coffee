'use strict'

angular.module('builder.edit').controller 'editCtrl', ($state, eeDefiner, eeModal, eeLanding, eeStorefront) ->

  this.ee = eeDefiner.exports

  this.show       = eeLanding.show
  this.data       = eeLanding.data
  this.fns        = eeLanding.fns

  this.setCarouselImage = (imgUrl) -> eeDefiner.exports.carousel.imgUrl = imgUrl
  this.setAboutImage    = (imgUrl) -> eeDefiner.exports.about.imgUrl = imgUrl
  this.save = () -> eeModal.fns.openSignupModal()

  eeLanding.fns.showState $state.current.name

  return

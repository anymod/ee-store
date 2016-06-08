'use strict'

angular.module('eeStore').controller 'modalCtrl', (eeBack, eeDefiner, eeModal) ->

  modal = this

  modal.ee = eeDefiner.exports
  # modal.alert = false
  #
  # modal.subscribe = () ->
  #   modal.submitting = true
  #   eeBack.fns.customerPOST modal.email
  #   .then (res) ->
  #     modal.alert = false
  #     eeModal.fns.close 'offer'
  #     eeModal.fns.open  'offer_thanks'
  #   .catch (err) -> modal.alert = 'Please check your email address.'
  #   .finally () -> modal.submitting = false

  return

'use strict'

angular.module('builder.terms').controller 'termsModalCtrl', ($modalInstance, eeModal) ->

  this.openPrivacyPolicyModal = () ->
    $modalInstance.close()
    eeModal.fns.openPrivacyPolicyModal()

  this.openSellerTermsModal = () ->
    $modalInstance.close()
    eeModal.fns.openSellerTermsModal()

  return

'use strict'

angular.module 'ee-signup', []

angular.module('ee-signup').directive 'eeSignup', (eeModal, eeBack) ->
  templateUrl: 'ee-shared/components/ee-signup.html'
  restrict: 'EA'
  scope: {}
  link: (scope, ele, attr) ->

    scope.subscribe = () ->
      scope.submitting = true
      eeBack.fns.customerPOST scope.email
      .then (res) ->
        scope.alert = false
        eeModal.fns.close 'offer'
        eeModal.fns.open  'offer_thanks'
      .catch (err) -> scope.alert = 'Please check your email address.'
      .finally () -> scope.submitting = false

    PinUtils?.build()
    FB?.XFBML?.parse()

    return

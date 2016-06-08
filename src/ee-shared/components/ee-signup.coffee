'use strict'

angular.module 'ee-signup', []

angular.module('ee-signup').directive 'eeSignup', (eeBack) ->
  templateUrl: 'ee-shared/components/ee-signup.html'
  restrict: 'EA'
  scope: {}
  link: (scope, ele, attr) ->

    scope.subscribe = () ->
      scope.submitting = true
      eeBack.fns.customerPOST scope.email
      .then (res) -> scope.alert = false
      .catch (err) -> scope.alert = 'Please check your email address.'
      .finally () -> scope.submitting = false

    PinUtils?.build()
    FB?.XFBML?.parse()

    return

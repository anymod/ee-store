'use strict'

angular.module('builder.contact').controller 'contactCtrl', (eeBack) ->
  this.alert    = ''
  this.btnText  = ''
  this.name     = ''
  this.email    = ''
  this.message  = ''
  this.success  = false

  that = this

  setBtnText    = (txt) -> that.btnText = txt
  resetBtnText  = ()    -> setBtnText 'Submit'
  resetBtnText()

  this.submit = () ->
    setBtnText 'Sending'
    eeBack.contactPOST that.name, that.email, that.message
    .then (res) -> that.success = true
    .catch (err) ->
      alert = err.message || err || 'Problem sending'
      if typeof alert is 'object' then alert = 'Problem sending'
      that.alert = alert
    .finally () -> resetBtnText()

  return

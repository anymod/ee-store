'use strict'

angular.module('store.help').controller 'helpCtrl', ($location, eeDefiner, eeBack) ->

  help = this

  help.ee = eeDefiner.exports

  setBtnText    = (txt) -> help.btnText = txt
  resetBtnText  = ()    -> setBtnText 'Send'
  resetBtnText()

  help.initiateReturn = () ->
    if !help.orderNumber then return help.returnAlert = 'Please enter your order number'
    help.initiating = true
    help.returnAlert = false
    eeBack.fns.contactPOST 'Return via ' + $location.host(), '', 'For order ' + help.orderNumber
    .then (res) ->
      help.orderNumber = null
      help.initiated = true
    .catch (err) ->
      alert = err.message || err || 'Problem sending'
      if typeof alert is 'object' then alert = 'Problem sending'
      help.returnAlert = alert
    .finally () -> help.initiating = false

  help.submit = () ->
    if !help.message then return help.alert = 'Please enter a message'
    setBtnText 'Sending'
    help.alert = false
    eeBack.fns.contactPOST help.name + ' (via ' + $location.host() + ')', help.email, help.message
    .then (res) -> help.success = true
    .catch (err) ->
      alert = err.message || err || 'Problem sending'
      if typeof alert is 'object' then alert = 'Problem sending'
      help.alert = alert
    .finally () -> resetBtnText()

  return

'use strict'

angular.module('store.help').controller 'helpCtrl', (eeBootstrap, eeBack) ->

  help = this

  help.ee =
    Collections:
      collections:  eeBootstrap?.collections
      nav:          eeBootstrap?.nav

  setBtnText    = (txt) -> help.btnText = txt
  resetBtnText  = ()    -> setBtnText 'Send'
  resetBtnText()

  help.initiateReturn = () ->
    # TODO use same method as help.submit to initiate return

  help.submit = () ->
    if !help.message then return help.alert = 'Please enter a message'
    setBtnText 'Sending'
    eeBack.fns.contactPOST help.name, help.email, help.message
    .then (res) -> help.success = true
    .catch (err) ->
      alert = err.message || err || 'Problem sending'
      if typeof alert is 'object' then alert = 'Problem sending'
      help.alert = alert
    .finally () -> resetBtnText()

  return

'use strict'

angular.module('builder.auth').controller 'logoutCtrl', ($state, eeAuth, eeStorefront, eeCatalog, eeSelection, eeOrders) ->
  eeStorefront.fns.logout()
  ## TODO re-implement reset functions (or equivalent)
  # eeCatalog.reset()
  # eeSelection.reset()
  # eeOrders.reset()
  eeAuth.fns.logout()
  return

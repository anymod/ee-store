# 'use strict'
#
# angular.module('store.core').factory 'eeModal', ($modal) ->
#
#   ## SETUP
#   _modals         = {}
#   _backdropClass  = 'white-background opacity-08'
#
#   _config =
#     offer:
#       templateUrl:    'store/modal/modal.offer.html'
#       controller:     'modalCtrl as modal'
#       backdropClass:  _backdropClass
#     offer_thanks:
#       templateUrl:    'store/modal/modal.offer.thanks.html'
#       controller:     'modalCtrl as modal'
#       backdropClass:  _backdropClass
#
#   ## PRIVATE FUNCTIONS
#   _open = (name) ->
#     if !name or !_config[name] then return
#     _modals[name] = $modal.open _config[name]
#     return
#
#   _close = (name) ->
#     if !_modals[name] then return
#     _modals[name].close()
#     return
#
#   ## EXPORTS
#   fns:
#     open:   (name) -> _open name
#     close:  (name) -> _close name

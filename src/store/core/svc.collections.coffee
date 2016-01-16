'use strict'

angular.module('store.core').factory 'eeCollections', (eeBootstrap) ->

  ## SETUP
  _data =
    reading:      false
    collections:  eeBootstrap?.collections
    nav:          eeBootstrap?.nav

  ## PRIVATE FUNCTIONS
  # none

  ## EXPORTS
  data: _data
  fns: {}

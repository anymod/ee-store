'use strict'

angular.module('store.core').factory 'eeUser', (eeBootstrap, categories) ->

  ## SETUP
  _data =
    reading: false
    user:
      storefront_meta: eeBootstrap?.storefront_meta
    categories: categories

  ## PRIVATE FUNCTIONS
  # none

  ## EXPORTS
  data: _data
  fns: {}

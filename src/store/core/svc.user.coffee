'use strict'

angular.module('store.core').factory 'eeUser', (eeBootstrap, categories) ->

  ## SETUP
  _data =
    reading: false
    user: {}
    categories: categories

  if eeBootstrap
    _data.user[attr] = eeBootstrap[attr] for attr in ['storefront_meta', 'logo', 'categorization_ids', 'home_carousel', 'home_arranged']

  ## PRIVATE FUNCTIONS
  # none

  ## EXPORTS
  data: _data
  fns: {}

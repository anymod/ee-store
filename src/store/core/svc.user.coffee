'use strict'

angular.module('store.core').factory 'eeUser', (eeBootstrap, eeBack, categories) ->

  ## SETUP
  _data =
    reading: false
    user: {}
    categories: categories

  if eeBootstrap
    _data.user[attr] = eeBootstrap[attr] for attr in ['storefront_meta', 'logo', 'categorization_ids', 'home_carousel', 'home_arranged']

  ## PRIVATE FUNCTIONS
  _getUser = () ->
    return if _data.reading
    _data.reading = true
    _data.user.home_carousel = []
    _data.user.home_arranged = []
    eeBack.fns.userGET()
    .then (user) -> _data.user[attr] = user[attr] for attr in Object.keys(user)
    .finally () -> _data.reading = false

  ## EXPORTS
  data: _data
  fns:
    getUser: _getUser

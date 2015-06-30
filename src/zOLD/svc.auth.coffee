'use strict'

angular.module('store.core').factory 'eeAuth', ($location, $q) ->

  fns:
    hasToken: () -> false
    getToken: () -> false

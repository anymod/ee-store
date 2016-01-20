'use strict'

angular.module('store.home').controller 'homeCtrl', ($rootScope, eeDefiner, eeProducts) ->

  home = this

  home.ee = eeDefiner.exports

  if $rootScope.pageDepth > 1 then eeProducts.fns.featured()

  return

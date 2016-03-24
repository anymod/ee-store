'use strict'

angular.module('store.home').controller 'homeCtrl', ($rootScope, eeDefiner, eeUser) ->

  home = this

  home.ee = eeDefiner.exports

  # if $rootScope.pageDepth > 1 then eeProducts.fns.featured()
  if $rootScope.pageDepth > 1 then eeUser.fns.getUser()

  return

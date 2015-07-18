'use strict'

angular.module('eeStore').controller 'storeCtrl', ($rootScope, $state, $location, eeBootstrap) ->

  storefront = this

  storefront.ee =
    meta: eeBootstrap?.storefront_meta
    carousel: eeBootstrap?.storefront_meta?.home?.carousel[0]

  storefront.data = eeBootstrap

  storefront.fns =
    update: () -> $rootScope.forceReload $location.path(), '?page=' + storefront.data.pagination.page

  return

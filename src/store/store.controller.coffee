'use strict'

angular.module('eeStore').controller 'storeCtrl', ($rootScope, $state, $location, eeBootstrap, eeModal) ->

  storefront = this

  storefront.ee =
    Collections:
      collections:  eeBootstrap?.collections
      nav:          eeBootstrap?.nav
    Products:
      storefront:
        products:   eeBootstrap?.products
        page:       eeBootstrap?.page
        perPage:    eeBootstrap?.perPage
        count:      eeBootstrap?.count
    User:
      user:
        storefront_meta: eeBootstrap?.storefront_meta
    meta:           eeBootstrap?.storefront_meta

  storefront.data = eeBootstrap

  storefront.fns =
    update: () -> $rootScope.forceReload $location.path(), '?page=' + storefront.data.pagination.page

  storefront.openCollectionsModal = () -> eeModal.fns.openCollectionsModal(storefront.ee?.Collections?.nav?.alphabetical)
  storefront.productsUpdate = () -> $rootScope.forceReload $location.path(), '?page=' + storefront.ee.Products.storefront.page

  return

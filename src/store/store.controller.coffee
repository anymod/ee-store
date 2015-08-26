'use strict'

angular.module('eeStore').controller 'storeCtrl', ($rootScope, $state, $location, eeBootstrap, eeModal) ->

  storefront = this

  storefront.ee =
    Collections:
      collections:          eeBootstrap?.collections
      carouselCollections:  eeBootstrap?.carouselCollections
      firstTenCollections:  eeBootstrap?.firstTenCollections
      afterTenCollections:  eeBootstrap?.afterTenCollections
    # meta: eeBootstrap?.storefront_meta

  storefront.data = eeBootstrap

  storefront.fns =
    update: () -> $rootScope.forceReload $location.path(), '?page=' + storefront.data.pagination.page

  storefront.openCollectionsModal = () -> eeModal.fns.openCollectionsModal(storefront.ee?.Collections?.collections)

  return

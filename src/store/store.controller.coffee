'use strict'

angular.module('eeStore').controller 'storeCtrl', ($rootScope, $state, $location, eeDefiner, eeModal) ->

  storefront = this

  storefront.ee = eeDefiner.exports

  # storefront.fns =
  #   update: () -> $rootScope.forceReload $location.path(), '?page=' + storefront.data.pagination.page

  storefront.params = $location.search()
  if storefront.params
    storefront.query = storefront.params.q

  if $state.current.name is 'storefront' then storefront.showSupranav = true

  storefront.openCollectionsModal = () -> eeModal.fns.openCollectionsModal(storefront.ee?.Collections?.nav?.alphabetical)
  storefront.productsUpdate = () ->
    $state.go 'storefront', { p: storefront.ee.Products.storefront.page }
    # $rootScope.forceReload $location.path(), '?p=' + storefront.ee.Products.storefront.page

  return

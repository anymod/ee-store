'use strict'

angular.module('eeStore').controller 'storeproductCtrl', ($rootScope, eeBootstrap, eeCart) ->

  storeproduct = this

  storeproduct.ee =
    Collections:
      collections:          eeBootstrap?.collections
      carouselCollections:  eeBootstrap?.carouselCollections
      firstTenCollections:  eeBootstrap?.firstTenCollections
      afterTenCollections:  eeBootstrap?.afterTenCollections

  storeproduct.data =
    storeproduct: eeBootstrap.storeProduct

  console.log storeproduct.data

  $rootScope.$on 'add:selection', (e, selection_id) ->
    eeCart.fns.addSelection selection_id, eeBootstrap.cart?.quantity_array

  return

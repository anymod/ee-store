'use strict'

angular.module('store.collections').controller 'collectionCtrl', ($rootScope, $location, eeBootstrap, categories) ->

  collection = this

  collection.categories = categories

  collection.ee =
    Collections:
      collections: eeBootstrap?.collections
      nav:         eeBootstrap?.nav

  collection.data =
    collection: eeBootstrap?.collection
    products:   eeBootstrap?.products
    page:       eeBootstrap?.page
    perPage:    eeBootstrap?.perPage
    count:      eeBootstrap?.count

  collection.update = () -> $rootScope.forceReload $location.path(), '?p=' + collection.data.page

  return

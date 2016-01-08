'use strict'

angular.module('store.categories').controller 'categoryCtrl', ($state, $stateParams, eeBootstrap) ->

  search = this

  search.ee =
    Products:
      products:     eeBootstrap?.products
      count:        eeBootstrap?.count
      page:         eeBootstrap?.page
      perPage:      eeBootstrap?.perPage
    Collections:
      collections:  eeBootstrap?.collections
      nav:          eeBootstrap?.nav

  search.update = () ->
    $state.go 'category', { id: $stateParams.id, title: $stateParams.title, p: search.ee.Products.page }

  return

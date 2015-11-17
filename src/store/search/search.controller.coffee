'use strict'

angular.module('store.search').controller 'searchCtrl', ($location, $state, eeBootstrap) ->

  search = this

  search.params = $location.search()

  search.ee =
    Products:
      products:     eeBootstrap?.products.rows
      count:        eeBootstrap?.products.count
      page:         eeBootstrap?.products.page
      perPage:      eeBootstrap?.products.perPage
    Collections:
      collections:  eeBootstrap?.collections
      nav:          eeBootstrap?.nav

  search.update = () ->
    search.ee.Products.page
    search.params.p = search.ee.Products.page
    $state.go 'search', search.params

  return

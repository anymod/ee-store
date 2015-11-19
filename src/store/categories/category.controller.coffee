'use strict'

angular.module('store.categories').controller 'categoryCtrl', (eeBootstrap) ->

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

  return

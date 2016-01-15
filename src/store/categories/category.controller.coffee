'use strict'

angular.module('store.categories').controller 'categoryCtrl', ($rootScope, $location, $state, $stateParams, eeBootstrap, categories) ->

  category = this

  category.id = $stateParams.id
  category.categories = categories

  for cat in category.categories
    if cat.id is parseInt(category.id) then category.title = cat.title

  category.ee =
    Products:
      products:     eeBootstrap?.products
      count:        eeBootstrap?.count
      page:         eeBootstrap?.page
      perPage:      eeBootstrap?.perPage
    Collections:
      collections:  eeBootstrap?.collections
      nav:          eeBootstrap?.nav
    User:
      user:
        storefront_meta: eeBootstrap?.storefront_meta

  category.update = () ->
    $rootScope.forceReload $location.path(), '?p=' + category.ee.Products.page
    # $state.go 'category', { id: $stateParams.id, title: $stateParams.title, p: search.ee.Products.page }

  return

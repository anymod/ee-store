'use strict'

angular.module('store.search').controller 'searchCtrl', ($rootScope, $location, $state, eeDefiner, eeProducts) ->

  search = this

  search.params = $location.search()
  search.ee = eeDefiner.exports

  if $rootScope.pageDepth > 1 then eeProducts.fns.search(search.params.q)

  search.update = () ->
    search.params.p = search.ee.Products.page
    $state.go 'search', search.params

  return

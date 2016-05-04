'use strict'

angular.module('store.search').controller 'searchCtrl', ($rootScope, $location, $state, eeDefiner, eeProducts, eeCollection) ->

  search = this

  search.params = $location.search()
  search.ee = eeDefiner.exports

  search.update = () -> eeProducts.fns.runQuery()

  if $state.current.name is 'collection' and $rootScope.pageDepth > 1
    eeCollection.fns.defineCollection $state.params.id, true

  return

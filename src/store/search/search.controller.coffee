'use strict'

angular.module('store.search').controller 'searchCtrl', ($rootScope, $location, $state, $scope, eeDefiner, eeProducts, eeCollection, categories) ->

  search = this

  search.params = $location.search()
  search.ee = eeDefiner.exports

  search.update = () -> eeProducts.fns.runQuery()

  if $state.current.name is 'collection' and $rootScope.pageDepth > 1
    eeCollection.fns.defineCollection $state.params.id, true

  return

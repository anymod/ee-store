'use strict'

angular.module('store.search').controller 'searchCtrl', ($rootScope, $location, $state, $scope, eeDefiner, eeProducts, eeCollection, categories) ->

  search = this

  search.params = $location.search()
  search.ee = eeDefiner.exports

  search.update = () -> eeProducts.fns.runQuery()

  if $rootScope.pageDepth > 1
    switch $state.current.name
      when 'collection', 'sale' then eeCollection.fns.defineCollection $state.params.id, true

  return

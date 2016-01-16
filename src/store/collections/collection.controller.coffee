'use strict'

angular.module('store.collections').controller 'collectionCtrl', ($rootScope, $stateParams, $state, eeDefiner, eeCollection) ->

  collection = this

  collection.ee = eeDefiner.exports
  collection.id = $stateParams.id

  for coll in collection.ee.Collections.nav.alphabetical
    if coll.id is parseInt(collection.id) then collection.title = coll.title

  if $rootScope.pageDepth > 1 then eeCollection.fns.defineCollection collection.id

  collection.update = () ->
    page = if collection.ee.Collection.inputs.page > 1 then collection.ee.Collection.inputs.page else null
    $state.go 'collection', { id: $stateParams.id, title: $stateParams.title, p: page }

  return

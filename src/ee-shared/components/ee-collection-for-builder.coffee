'use strict'

module = angular.module 'ee-collection-for-builder', []

module.directive "eeCollectionForBuilder", ($state, $window, eeCollections) ->
  templateUrl: 'ee-shared/components/ee-collection-for-builder.html'
  restrict: 'E'
  scope:
    collection: '='
    modal: '@'
  link: (scope, ele, attrs) ->

    scope.updateCollection = () ->
      scope.collection.updating = true
      eeCollections.fns.updateCollection scope.collection
      .then () -> $state.go 'collections'
      .catch (err) -> scope.collection.err = err
      .finally () -> scope.collection.updating = false

    scope.deleteCollection = (coll) ->
      deleteCollection = $window.confirm 'Remove this from your store?'
      if deleteCollection
        scope.collection.destroying = true
        eeCollections.fns.destroyCollection (coll || scope.collection)
        .then () -> if !coll then scope.collection.removed = true else coll.removed = true
        .catch (err) -> scope.collection.err = err
        .finally () -> scope.collection.destroying = false

    scope.toggleCarousel = () ->
      if scope.collection?.banner?.indexOf('placehold.it') > -1
        $state.go 'collectionEdit', { id: scope.collection.id }
      else
        scope.collection.in_carousel = !scope.collection.in_carousel
        scope.updateCollection()

    scope.toggleAddToStore = () ->
      if scope.collection.added
        scope.deleteCollection scope.collection.cloned
        .then () -> scope.collection.added = false
      else
        eeCollections.fns.cloneCollection scope.collection
        .then (res) ->
          scope.collection.cloned = res.collection
          scope.collection.added = true

    scope.editOrOpenModal = () ->
      if !scope.modal then return $state.go 'collectionEdit', { id: scope.collection?.id }
      console.log 'Open modal with products'

    return

'use strict'

module = angular.module 'ee-collection-editor-card', []

module.directive "eeCollectionEditorCard", ($state, $window, eeCollections) ->
  templateUrl: 'ee-shared/components/ee-collection-editor-card.html'
  restrict: 'E'
  scope:
    collection: '='
    expanded:   '@'
  link: (scope, ele, attrs) ->

    scope.save_status = 'Save'
    scope.saved       = true
    scope.expanded  ||= false

    scope.updateCollection = () ->
      scope.collection.updating = true
      eeCollections.fns.updateCollection scope.collection
      .then () ->
        scope.saved    = true
        scope.expanded = false
      .catch (err) -> scope.collection.err = err
      .finally () -> scope.collection.updating = false

    scope.deleteCollection = () ->
      deleteCollection = $window.confirm 'Remove this from your store?'
      if deleteCollection
        scope.save_status = 'Removing'
        eeCollections.fns.destroyCollection scope.collection
        .then () ->
          scope.collection.removed = true
          $state.go 'collections'
        .catch (err) -> scope.save_status = 'Problem removing'


    # scope.addToCarousel = () ->
    #   scope.collection.in_carousel = true
    #   scope.updateCollection()
    #
    # scope.removeFromCarousel = () ->
    #   scope.collection.in_carousel = false
    #   scope.updateCollection()

    scope.toggleCarousel = () ->
      scope.collection.in_carousel = !scope.collection.in_carousel
      scope.updateCollection()

    scope.expand = () ->
      scope.expanded = true
      n = 0
      scope.$watch () ->
        return scope.collection
      , (newVal, oldVal) ->
        if oldVal and oldVal.id and n > 0 then scope.saved = false
        if n is 0 then n += 1
      , true

    return

'use strict'

module = angular.module 'ee-collection-editor-card', []

module.directive "eeCollectionEditorCard", ($state, $window, eeCollection) ->
  templateUrl: 'ee-shared/components/ee-collection-editor-card.html'
  restrict: 'E'
  scope:
    collection: '='
  link: (scope, ele, attrs) ->

    scope.data = eeCollection.data
    scope.save_status = 'Saved'
    scope.save_bool   = false

    scope.updateCollection = () ->
      scope.save_status = 'Saving'
      eeCollection.fns.updateCollection()
      .then () ->
        scope.save_status = 'Saved'
        scope.save_bool   = true
      .catch (err) -> scope.save_status = 'Problem saving'

    scope.deleteCollection = () ->
      deleteCollection = $window.confirm 'Delete this collection?'
      if deleteCollection
        eeCollection.fns.destroyCollection scope.collection.id
        .then () -> $state.go 'collections'

    scope.$watch () ->
      return scope.collection
    , (newVal, oldVal) ->
      if oldVal and oldVal.id
        if scope.save_status is 'Saved' and !scope.save_bool
          scope.save_bool = true
          scope.save_status = 'Save'
        else
          scope.save_bool = false
    , true

    return

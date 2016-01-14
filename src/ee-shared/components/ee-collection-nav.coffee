'use strict'

angular.module 'ee-collection-nav', []

angular.module('ee-collection-nav').directive "eeCollectionNav", ($state, eeModal, eeBootstrap) ->
  templateUrl: 'ee-shared/components/ee-collection-nav.html'
  restrict: 'E'
  replace: true
  scope:
    collections: '='
    limit:       '='
  link: (scope, ele, attrs) ->
    scope.$state = $state
    scope.ee =
      User:
        user:
          storefront_meta: eeBootstrap?.storefront_meta
    scope.openCollectionsModal = () -> eeModal.fns.openCollectionsModal scope.collections
    return

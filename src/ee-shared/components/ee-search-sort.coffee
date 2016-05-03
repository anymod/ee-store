'use strict'

angular.module 'ee-search-sort', []

angular.module('ee-search-sort').directive 'eeSearchSort', ($state, eeProducts) ->
  templateUrl: 'ee-shared/components/ee-search-sort.html'
  restrict: 'EA'
  scope: {}
  link: (scope, ele, attr) ->
    scope.data  = eeProducts.data
    scope.fns   = eeProducts.fns

    scope.search = () -> return

    scope.$on 'pagination:clicked', () ->
      # eeProducts.fns.runQuery()
      page = if scope.data.inputs?.page? > 1 then scope.data.inputs.page else null
      $state.go 'category', { id: $stateParams.id, title: $stateParams.title, p: page }

    return

'use strict'

angular.module('store.categories').controller 'categoryCtrl', ($rootScope, $location, $state, $stateParams, eeDefiner, eeProducts) ->

  category = this

  category.ee = eeDefiner.exports
  category.id = $stateParams.id

  for cat in category.ee.User.categories
    if cat.id is parseInt(category.id) then category.title = cat.title

  if $rootScope.pageDepth > 1 then eeProducts.fns.setCategory()

  category.update = () ->
    # eeProducts.fns.runQuery()
    page = if category.ee.Products.inputs.page > 1 then category.ee.Products.inputs.page else null
    $state.go 'category', { id: $stateParams.id, title: $stateParams.title, p: page }

  return

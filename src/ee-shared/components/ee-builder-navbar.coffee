angular.module 'ee-builder-navbar', []

angular.module('ee-builder-navbar').directive "eeBuilderNavbar", ($window, $state, eeDefiner, eeProducts) ->
  templateUrl: 'ee-shared/components/ee-builder-navbar.html'
  restrict: 'E'
  scope:
    showDropdown: '@'
    search: '@'
    live: '@'
    signin: '@'
    transparent: '@'
    fixed: '@'
    mainNav: '@'
    playbookNav: '@'
    productsNav: '@'
    editNav: '@'
    orderNav: '@'
    accountNav: '@'
    noShadow: '@'
  link: (scope, ele, attrs) ->
    scope.ee = eeDefiner.exports
    scope.productsFns = eeProducts.fns

    switch $state.current?.name
      when 'daily', 'tracks', 'brand', 'store', 'start' then scope.btn1Active = true
      when 'collections', 'categories', 'products', 'collectionsAdd', 'collection' then scope.btn2Active = true
      when 'orders' then scope.btn3Active = true

    scope.runSearch = () ->
      $state.go 'products'
      eeProducts.fns.search scope.ee.Products?.search?.inputs?.search

    return

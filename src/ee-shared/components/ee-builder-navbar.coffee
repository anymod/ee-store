angular.module 'ee-builder-navbar', []

angular.module('ee-builder-navbar').directive "eeBuilderNavbar", ($window, $state, eeDefiner, eeProducts) ->
  templateUrl: 'ee-shared/components/ee-builder-navbar.html'
  restrict: 'E'
  scope:
    logo: '@'
    dropdown: '@'
    home: '@'
    save: '@'
    back: '@'
    signin: '@'
    search: '@'
    live: '@'
    transparent: '@'
    fixed: '@'
    storefront: '@'
    # collections: '@'
    # collectionId: '@'
    product: '@'
    productsNav: '@'
    editNav: '@'
    orderNav: '@'
    noShadow: '@'
  link: (scope, ele, attrs) ->
    scope.ee = eeDefiner.exports
    scope.productsFns = eeProducts.fns

    scope.runSearch = () ->
      $state.go 'products'
      eeProducts.fns.search scope.ee.Products?.search?.inputs?.search

    return

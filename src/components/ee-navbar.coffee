angular.module 'ee-navbar', []

angular.module('ee-navbar').directive "eeNavbar", (eeDefiner, eeModal) ->
  templateUrl: 'components/ee-navbar.html'
  restrict: 'E'
  scope:
    transparent: '@'
    fixed: '@'
    signin: '@'
    storefront: '@'
    products: '@'
    save: '@'
    dropdown: '@'
    back: '@'
  link: (scope, ele, attrs) ->
    scope.ee        = eeDefiner.exports
    scope.feedback  = () -> eeModal.fns.open 'feedback'
    scope.catalog   = eeModal.fns.openCatalogModal
    return

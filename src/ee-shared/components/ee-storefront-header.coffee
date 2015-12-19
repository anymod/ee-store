'use strict'

module = angular.module 'ee-storefront-header', []

module.directive "eeStorefrontHeader", ($rootScope, $state, $window, eeCart) ->
  templateUrl: 'ee-shared/components/ee-storefront-header.html'
  scope:
    meta:           '='
    blocked:        '='
    fluid:          '@'
    loading:        '='
    collections:    '='
    quantityArray:  '='
    query:          '='
    showSupranav:   '='
    showScrollnav:  '='
  link: (scope, ele, attrs) ->
    scope.isStore     = $rootScope.isStore
    scope.isBuilder   = $rootScope.isBuilder
    scope.state       = $state.current.name
    scope.cart        = eeCart.cart

    scope.categories = [
      { id: 1, title: 'Artwork' }
      { id: 2, title: 'Bed & Bath' }
      { id: 3, title: 'Furniture' }
      { id: 4, title: 'Home Accents' }
      { id: 5, title: 'Kitchen' }
      { id: 6, title: 'Outdoor' }
    ]

    if scope.showScrollnav
      trigger = 75
      angular.element($window).bind 'scroll', (e, a, b) ->
        if $window.pageYOffset > trigger then ele.addClass 'show-scrollnav' else ele.removeClass 'show-scrollnav'

    if scope.showScrollToTop
      trigger = 150
      angular.element($window).bind 'scroll', (e, a, b) ->
        if $window.pageYOffset > trigger then ele.addClass 'show-scrolltop' else ele.removeClass 'show-scrolltop'

    scope.search = (query, page) ->
      $state.go 'search', { q: (query || scope.query), p: (page || scope.page) }

    $rootScope.$on 'search:query', (e, query) -> scope.search query, 1

    return

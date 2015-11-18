'use strict'

module = angular.module 'ee-storefront-header', []

module.directive "eeStorefrontHeader", ($rootScope, $state, $window, eeCart, eeModal) ->
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
    scope.openCollectionsModal = () -> eeModal.fns.openCollectionsModal scope.collections

    if scope.showScrollnav
      position = $window.pageYOffset
      trigger = 75
      angular.element($window).bind 'scroll', (e, a, b) ->
        if $window.pageYOffset > trigger then ele.addClass 'show-scrollnav' else ele.removeClass 'show-scrollnav'

    # if scope.showSupranav
    #   position = $window.pageYOffset
    #   trigger = 15
    #   angular.element($window).bind 'scroll', (e, a, b) ->
    #     if $window.pageYOffset > trigger then ele.addClass 'slid-up' else ele.removeClass 'slid-up'
    #     # new_pos = $window.pageYOffset
    #     # if new_pos < position then ele.removeClass 'slid-up'
    #     # if new_pos > position + trigger then ele.addClass 'slid-up'
    #     # if new_pos < position or new_pos > position + trigger then position = new_pos

    scope.search = (query, page) ->
      $state.go 'search', { q: (query || scope.query), p: (page || scope.page) }

    $rootScope.$on 'search:query', (e, query) -> scope.search query, 1

    return

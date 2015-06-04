'use strict'

angular.module 'ee-offscreen', []

angular.module('ee-offscreen').directive "eeOffscreen", ($rootScope) ->
  templateUrl: 'builder/storefront/storefront.offscreen.view.container.html'
  restrict: 'E'
  scope:
    offscreenCategory: '='
    offscreenColor: '='
  link: (scope, ele, attrs) ->
    scope.$on '$stateChangeSuccess', (event, toState) ->
      scope.toggle = $rootScope.toggle

    scope.$on 'auth:user:updated', (e, data) ->
      scope.user = data

    scope.toggleOffscreen = () ->
      $rootScope.toggle = !$rootScope.toggle
      scope.toggle = $rootScope.toggle

    return

## Default offscreen
angular.module('ee-offscreen').directive "eeOffscreenDefault", () ->
  templateUrl: 'builder/templates/template.offscreen.default.html'
  restrict: 'E'
  scope: {}
  link: (scope, ele, attrs) ->
    return

## Storefront offscreens

#  Parent
angular.module('ee-offscreen').directive "eeOffscreenStorefront", ($state) ->
  templateUrl: 'builder/storefront/storefront.offscreen.html'
  restrict: 'E'
  link: (scope, ele, attrs) ->
    scope.$state = $state
    scope.$on 'storefront:updated', (e, data) ->
      scope.storefront = data
    return

# Home
angular.module('ee-offscreen').directive "eeOffscreenStorefrontHome", (eeStorefront, eeAuth) ->
  templateUrl: 'builder/storefront/storefront.offscreen.home.html'
  restrict: 'E'
  link: (scope, ele, attrs) ->
    eeStorefront.getStorefront()
    .then (storefront) -> eeStorefront.setScopeCategories(storefront, scope)
    return

# Shop
angular.module('ee-offscreen').directive "eeOffscreenStorefrontShop", () ->
  templateUrl: 'builder/storefront/storefront.offscreen.shop.html'
  restrict: 'E'
  link: (scope, ele, attrs) ->
    scope.$on 'storefront:categories:updated', (data) ->
      scope.categories = data
    return

# Blog
angular.module('ee-offscreen').directive "eeOffscreenStorefrontBlog", () ->
  templateUrl: 'builder/storefront/storefront.offscreen.blog.html'
  restrict: 'E'
  link: (scope, ele, attrs) ->
    return

# About
angular.module('ee-offscreen').directive "eeOffscreenStorefrontAbout", () ->
  templateUrl: 'builder/storefront/storefront.offscreen.about.html'
  restrict: 'E'
  link: (scope, ele, attrs) ->
    $('.upload_form').append($.cloudinary.unsigned_upload_tag("storefront_about", { cloud_name: 'eeosk' }))
    return

# Audience
angular.module('ee-offscreen').directive "eeOffscreenStorefrontAudience", () ->
  templateUrl: 'builder/storefront/storefront.offscreen.audience.html'
  restrict: 'E'
  link: (scope, ele, attrs) ->
    return

## Catalog
angular.module('ee-offscreen').directive "eeOffscreenCatalog", ($location, eeCatalog) ->
  templateUrl: 'builder/catalog/catalog.offscreen.html'
  restrict: 'E'
  scope: {}
  link: (scope, ele, attrs) ->
    scope.currentCategories = []
    scope.currentRanges = []
    scope.categories = [
      'Home Accents',
      'Kitchen',
      # 'Apparel',
      'Accessories',
      'Health & Beauty',
      'Electronics',
      'General Merchandise'
    ]
    scope.ranges = [
      { min: 0,     max: 2500   },
      { min: 2500,  max: 5000   },
      { min: 5000,  max: 10000  },
      { min: 10000, max: 20000  },
      { min: 20000, max: null   }
    ]

    scope.query = eeCatalog.getQuery()
    scope.$on 'catalog:query:updated', () ->
      scope.query = eeCatalog.getQuery()

    scope.categoryIsCurrent = (category) -> scope.currentCategories.indexOf(category) > -1

    scope.toggleCurrentCategory = (category) ->
      index = scope.currentCategories.indexOf category
      if index > -1 then scope.currentCategories.splice(index, 1) else scope.currentCategories.push category
      eeCatalog.addQuery 'categories', scope.currentCategories.join(',')
      eeCatalog.addQuery 'page', 1
      # eeCatalog.logQuery()
      eeCatalog.search()

    fillCurrentRanges = (min, max) ->
      scope.currentRanges = []
      pushRange = (r) ->
        if r.min >= min and ((r.max <= max and r.max isnt null) or max is null)
          scope.currentRanges.push r
      pushRange r for r in scope.ranges

    setMinMax = (min, max) ->
      eeCatalog.addQuery 'min', min
      eeCatalog.addQuery 'max', max
      eeCatalog.addQuery 'page', 1
      # eeCatalog.logQuery()
      eeCatalog.search()

    translateRanges = () ->
      [mins, maxs] = [[],[]]
      scope.currentRanges.map (r) ->
        mins.push r.min
        maxs.push r.max
      min = Math.min.apply null, mins
      max = Math.max.apply null, maxs
      if maxs.indexOf(null) > -1 then max = null
      fillCurrentRanges min, max
      setMinMax min, max

    scope.rangeIsCurrent = (range) -> scope.currentRanges.indexOf(range) > -1

    scope.toggleCurrentRange = (range) ->
      index = scope.currentRanges.indexOf range
      if index > -1 then scope.currentRanges.splice(index, 1) else scope.currentRanges.push range
      translateRanges()

    return

## Orders
angular.module('ee-offscreen').directive "eeOffscreenOrders", () ->
  templateUrl: 'builder/orders/orders.offscreen.html'
  restrict: 'E'
  scope: {}
  link: (scope, ele, attrs) -> return

## Account
angular.module('ee-offscreen').directive "eeOffscreenAccount", (eeStorefront, eeAuth) ->
  templateUrl: 'builder/account/account.offscreen.html'
  restrict: 'E'
  link: (scope, ele, attrs) ->
    eeAuth.setScopeUser(scope)
    return

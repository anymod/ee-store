'use strict'

angular.module('builder.catalog').controller 'builder.catalog.offscreenCtrl', ($scope, $rootScope, $location, user, eeAuth, eeCatalog, eeSelection, eeStorefront) ->
  ## Setup definitions
  $scope.user = user
  # Search
  $scope.categoryArray      = eeCatalog.categoryArray
  $scope.rangeArray         = eeCatalog.rangeArray
  $scope.margin_array        = eeCatalog.margin_array
  # Offscreen product
  basePrice                 = null
  $scope.currentPrice       = null
  $scope.currentMargin      = null
  $scope.addBtnDisabled     = false
  $scope.removeBtnDisabled  = false
  ##

  ## Setup functions
  # Respond to searches
  $scope.$on 'catalog:search:started', () -> $scope.searching  = true
  $scope.$on 'catalog:updated', (e, data) ->
    # offscreen scope only needs search params
    $scope.search   = data.search
    $scope.min      = data.min
    $scope.max      = data.max
    $scope.category = data.category
    $scope.storefront_product_ids = data.storefront_product_ids
    $scope.product_selection  = data.product_selection
    # reflect status on buttons
    $scope.searching = false
    $scope.addBtnDisabled = false
    $scope.removeBtnDisabled = false
  # Generate searches
  $scope.setCategory  = (category) ->
    $scope.category = if category is $scope.category then null else category
    eeCatalog.setCategory $scope.category
  $scope.setRange = (range) ->
    if range.min is $scope.min and range.max is $scope.max then range = {}
    $scope.min = range.min
    $scope.max = range.max
    eeCatalog.setRange range
  $scope.setSearch = () ->
    eeCatalog.setSearchTerm $scope.search

  # Offscreen product
  setProduct          = (prod) -> $scope.product = prod
  clearProduct        = () -> setProduct {}
  $scope.update       = (newMargin) -> eeCatalog.setCurrents $scope, basePrice, newMargin
  $scope.setFocusImg  = (img) -> $scope.focusImg = img
  initializeProduct   = (prod) ->
    productInStorefront = eeCatalog.getProductSelection()[prod.id]
    setProduct prod
    basePrice = $scope.product.baseline_price
    $scope.setFocusImg prod.image_meta.main_image
    if !!productInStorefront?.selling_price
      $scope.currentPrice   = productInStorefront.selling_price
      $scope.currentProfit  = productInStorefront.selling_price - basePrice
      $scope.currentMargin  = Math.round((1 - (basePrice / productInStorefront.selling_price)) * 1000) / 1000
    else
      $scope.update eeCatalog.start_margin

  ## Focus product
  $scope.$on 'product:focus', (e, id) ->
    $scope.loadingProduct = true
    eeCatalog.getProduct id
    .then (product) -> initializeProduct product
    .catch (err) -> console.error 'Error loading product', err
    .finally () -> $scope.loadingProduct = false

  $scope.productInStorefront = (id) ->
    $scope.storefront_product_ids?.indexOf(id) > -1

  ## Add to store
  $scope.addToStore = () ->
    $scope.addBtnDisabled = true
    eeSelection.createSelection($scope.product, $scope.currentMargin*100)
    .catch (err) -> console.error err

  ## Remove from store
  $scope.removeFromStore = () ->
    $scope.removeBtnDisabled  = true
    selection_id = $scope.product_selection[$scope.product.id].selection_id
    eeSelection.deleteSelection(selection_id)
    .catch (err) -> console.error err

  ## Close offscreen product focus
  $scope.closeProduct = () ->
    $scope.loadingProduct = false
    clearProduct()

  return

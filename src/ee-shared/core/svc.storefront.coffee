'use strict'

angular.module('app.core').factory 'eeStorefront', ($rootScope, $q, $location, eeAuth, eeBack) ->

  ## SETUP
  _status =
    fetching:           false

  ## PRIVATE EXPORT DEFAULTS
  _data = {}

  _reset = () ->
    _data.product_selection = []
    _data.product_ids       = []
    _data.categories        = ['All']
    _data.loading           = false

  _reset()

  ## PRIVATE FUNCTIONS
  _inStorefront   = (id)           -> _data.product_ids.indexOf(id) > -1
  _getProductSelection = (product) ->
    if !product?.id or !_inStorefront(product.id) then return false
    index = _data.product_ids.indexOf(product.id)
    _data.product_selection[index]

  _addProductSel  = (p_s, psArray)      -> if !!p_s and !!p_s.product_id then psArray.push p_s
  _addProductId   = (id, ids)           -> if !!id  and (ids.indexOf(id) < 0) then ids.push id
  _addCategory    = (cat, categories)   -> if !!cat and (categories.indexOf(cat) < 0) then categories.push cat

  _setCategories  = () ->
    categories = ['All']
    _addCategory(p_s.category, categories) for p_s in _data.product_selection
    _data.categories = categories
    return

  _defineData = (product_selection) ->
    if !!product_selection
      _data.product_selection.length = 0
      _addProductSel(p_s, _data.product_selection) for p_s in product_selection

    defineIdAndCategory = (p_s) ->
      _addProductId   p_s.product_id, _data.product_ids
      _addCategory    p_s.category,   _data.categories

    _data.product_ids.length = 0
    _data.categories.length  = 0
    _data.categories.push 'All'
    defineIdAndCategory p_s for p_s in _data.product_selection
    return

  _storefrontIsEmpty = () -> _data.product_selection.length is 0

  _defineStorefrontFromToken = () ->
    deferred = $q.defer()

    if !!_status.fetching then return _status.fetching
    if !eeAuth.fns.getToken() then deferred.reject('Missing login credentials'); return deferred.promise
    _status.fetching = deferred.promise

    eeBack.usersStorefrontGET eeAuth.fns.getToken()
    .then (data) ->
      _defineData data.product_selection
      deferred.resolve data
    .catch (err) -> deferred.reject err
    .finally () -> _status.fetching = false
    deferred.promise

  _defineCustomerStore = () ->
    deferred  = $q.defer()

    if !!_status.fetching then return _status.fetching
    host      = $location.host()
    username  = host.split('.')[0]

    if !!host and (host is 'localhost' or host.indexOf('herokuapp') > -1) then username = 'demoseller'

    if !username then deferred.reject('Missing username'); return deferred.promise

    eeBack.storefrontGET username
    .then (storefront) ->
      _defineData storefront.product_selection
      $rootScope.storeName = storefront.storefront_meta?.home?.name
      deferred.resolve storefront
    .catch (err) -> deferred.reject err
    .finally () -> _status.fetching = false
    deferred.promise

  _addDummyProduct = (product) ->
    p_s =
      product_id:         product.id
      supplier_id:        product.supplier_id
      selling_price:      product.calculated.selling_price
      suggested_price:    product.suggested_price
      shipping_price:     product.shipping_price
      title:              product.title
      content:            product.content
      content_meta:       product.content_meta
      image_meta:         product.image_meta
      availability_meta:  product.availability_meta
      category:           product.category
      dummy_only:
        margin:           product.calculated.margin*100
    _data.product_selection.push p_s

  _addProduct = (product) ->
    eeBack.selectionsPOST(eeAuth.fns.getToken(), {
      product_id:   product.id
      supplier_id:  product.supplier_id
      margin:       product.calculated.margin*100
    })
    .then (res) -> _defineStorefrontFromToken()
    .catch (err) -> console.error err

  _removeProductSelection = (p_s) ->
    eeBack.selectionsDELETE eeAuth.fns.getToken(), p_s.selection_id
    .then (res) -> _defineStorefrontFromToken()
    .catch (err) -> console.error err

  _updateProductSelection = (p_s, product) ->
    eeBack.selectionsPUT eeAuth.fns.getToken(), p_s.selection_id, {
      product_id:   product.id
      supplier_id:  product.supplier_id
      margin:       product.calculated.margin*100
    }

  _updateDummyProductSelection = (p_s, product) ->
    p_s.selling_price = product.calculated.selling_price
    return

  ## EXPORTS
  data: _data
  fns:
    logout: _reset

    defineStorefrontFromToken:    _defineStorefrontFromToken
    defineCustomerStore:          _defineCustomerStore
    inStorefront:                 _inStorefront

    setCategories:                _setCategories
    addProduct:                   _addProduct
    getProductSelection:          _getProductSelection
    removeProductSelection:       _removeProductSelection
    updateProductSelection:       _updateProductSelection
    updateDummyProductSelection:  _updateDummyProductSelection

    addDummyProduct: (product) ->
      if !product.calculated then return console.error('Problem adding dummy product')
      if !_inStorefront product.id then _addDummyProduct product
      _defineData()

    removeDummyProductSelection: (p_s) ->
      index = _data.product_ids.indexOf p_s.product_id
      if index > -1 then _data.product_selection.splice index, 1
      _defineData()

    setTheme: (meta, theme) ->
      if !meta.home.carousel[0] then meta.home.carousel[0] = {}
      meta.home.topBarColor           = theme.topBarColor
      meta.home.topBarBackgroundColor = theme.topBarBackgroundColor
      meta.home.carousel[0].imgUrl    = theme.imgUrl
      return

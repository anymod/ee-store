'use strict'

angular.module('store.core').factory 'eeProducts', ($rootScope, $q, $state, $stateParams, $location, eeBootstrap, eeBack, categories) ->

  ## SETUP
  _inputDefaults =
    perPage:      eeBootstrap?.perPage
    page:         eeBootstrap?.page
    search:       $stateParams.q || null
    searchLabel:  null
    range:
      min:        null
      max:        null
    category:     eeBootstrap?.category || $stateParams.c
    categories:   categories
    collection_id: eeBootstrap?.collection_id
    order:        { order: null, title: 'Most relevant' }
    rangeArray: [
      { min: 0,     max: 2500,  str: '0-25' }
      { min: 2500,  max: 5000,  str: '25-50' }
      { min: 5000,  max: 10000, str: '50-100' }
      { min: 10000, max: 20000, str: '100-200' }
      { min: 20000, max: null,  str: '200-0' }
    ]
    orderArray: [
      { order: null,  title: 'Most relevant' }
      { order: 'pa',  title: 'Price, low to high',  use: true } # price ASC (pa)
      { order: 'pd',  title: 'Price, high to low',  use: true } # price DESC (pd)
      { order: 'ta',  title: 'A to Z',              use: true } # title ASC (ta)
      { order: 'td',  title: 'Z to A',              use: true } # title DESC (td)
    ]
  if eeBootstrap?.order
    for order in _inputDefaults.orderArray
      if order.order is eeBootstrap.order then _inputDefaults.order = angular.copy order
  if eeBootstrap?.range
    [min, max] = eeBootstrap?.range.split('-')
    for range in _inputDefaults.rangeArray
      if range.min is parseInt(min)*100 then _inputDefaults.range = angular.copy range
  if eeBootstrap?.categorization_ids
    cats = []
    for category in _inputDefaults.categories
      if eeBootstrap.categorization_ids.indexOf(category.id) > -1 then cats.push category
    _inputDefaults.categories = cats
  if eeBootstrap?.category
    eeBootstrap.category = parseInt eeBootstrap.category
    for category in _inputDefaults.categories
      if category.id is eeBootstrap.category then _inputDefaults.category = angular.copy category
  if eeBootstrap?.collection_id
    eeBootstrap.collection_id = parseInt eeBootstrap.collection_id

  ## PRIVATE EXPORT DEFAULTS
  _data =
    inputs:   angular.copy _inputDefaults
    reading:  false
    products: eeBootstrap?.products
    count:    eeBootstrap?.count

  ## PRIVATE FUNCTIONS
  _clearProducts = () ->
    _data.products = []
    _data.count    = 0
    _data.inputs.size = null

  _setPage = (p) -> _data.inputs.page = p

  _setRange = (range) ->
    range ||= {}
    if _data.inputs.range.min is range.min and _data.inputs.range.max is range.max
      _data.inputs.range.min = null
      _data.inputs.range.max = null
    else
      _data.inputs.range.min = range.min
      _data.inputs.range.max = range.max
    _setPage null

  _setRangeByString = (rangeStr) ->
    # '0-50'
    return unless rangeStr?
    for range in _data.inputs.rangeArray
      if range.str is rangeStr then return _data.inputs.range = range
    _setPage null

  _setCategoryById = (category_id) ->
    _setPage null
    return _data.inputs.category = null unless category_id?
    for cat in _data.inputs.categories
      if cat.id is parseInt(category_id) then return _data.inputs.category = cat

  _setCollectionById = (collection_id) ->
    _data.inputs.collection_id = if collection_id? then parseInt(collection_id) else null
    _setPage null

  _setSort = (order) ->
    if !order? then order = _data.inputs.orderArray[0]
    _data.inputs.order = order
    _setPage null

  _setSortByString = (sortStr) ->
    # 'pa'
    return unless sortStr?
    for order in _data.inputs.orderArray
      if order.order is sortStr then return _data.inputs.order = order
    _setPage null

  _setSearch = (term) ->
    if term? then _data.inputs.search = term
    _setPage null

  _setUrlParams = () ->
    str = if _data.inputs.range?.min? or _data.inputs.range?.max? then [_data.inputs.range.min/100, _data.inputs.range.max/100].join('-') else null
    $stateParams.r = str
    $stateParams.p = _data.inputs.page
    $stateParams.c = _data.inputs.category?.id
    $stateParams.s = _data.inputs.order?.order?.replace(/ /g, '_')
    $stateParams.q = _data.inputs.search
    $stateParams.coll = _data.inputs.collection_id
    $location.search 'r', str
    $location.search 'p', _data.inputs.page
    $location.search 'c', _data.inputs.category?.id
    $location.search 's', _data.inputs.order?.order?.replace(/ /g, '_')
    $location.search 'q', _data.inputs.search
    $location.search 'coll', _data.inputs.collection_id

  _formQuery = () ->
    query = {}
    query.size = _data.inputs.perPage
    if _data.inputs.page?         then query.page           = _data.inputs.page
    if _data.inputs.size?         then query.size           = _data.inputs.size
    if _data.inputs.search?       then query.search         = _data.inputs.search
    if _data.inputs.range.min?    then query.min_price      = _data.inputs.range.min
    if _data.inputs.range.max?    then query.max_price      = _data.inputs.range.max
    if _data.inputs.order.use?    then query.order          = _data.inputs.order.order
    if _data.inputs.category?.id? then query.category_ids   = [_data.inputs.category.id]
    if _data.inputs.collection_id? then query.collection_id  = _data.inputs.collection_id
    query

  _runQuery = (skipUrl) ->
    if _data.reading then return $q.when()
    _data.reading = true
    _setUrlParams() unless skipUrl
    eeBack.fns.productsGET _formQuery()
    .then (res) ->
      { rows, count, took } = res
      _data.products  = rows
      _data.count     = count
      _data.took      = took
      _data.inputs.searchLabel = _data.inputs.search
    .catch (err) -> _data.count = null
    .finally () -> _data.reading = false

  _search = (term) ->
    _clearProducts()
    _setSearch term
    _runQuery()

  _searchLike = (term, category_id) ->
    _clearProducts()
    _setSort null
    _setCategoryById category_id
    _data.inputs.search = term
    _data.inputs.size   = 9
    _runQuery(true)
    .then () ->
      products = []
      for prod, i in _data.products
        if products.length < 8 and prod.title isnt term then products.push prod
      _data.products = products
      _data.inputs.size = _inputDefaults.perPage
      return

  ## MESSAGING
  $rootScope.$on 'reset:page', () -> _setPage null

  $rootScope.$on '$stateChangeStart', (e, toState, toParams, fromState, fromParams) ->
    _setSearch        toParams.q
    _setPage          toParams.p
    _setSortByString  toParams.s
    _setRangeByString toParams.r
    _setCategoryById  toParams.c
    _setCollectionById toParams.coll
    switch toState.name
      when 'storefront'
        _setSearch ''
        _setSort null
        _setRange null
        _setCategoryById null
        _setCollectionById null
      when 'category'
        _setCategoryById toParams.id
        _setCollectionById null
      when 'collection'
        _setCollectionById toParams.id
        _setCategoryById null
      when 'search'
        _setCollectionById null
    switch toState.name
      when 'search', 'category', 'collection' then _runQuery(true)
    return

  ## EXPORTS
  data: _data
  fns:
    runQuery: _runQuery
    search: _search
    searchLike: _searchLike
    clearSearch: () -> _search ''
    setCategory: (category) ->
      _clearProducts()
      _setCategoryById category.id
      _runQuery()
    setOrder: (order) ->
      _clearProducts()
      _setSort order
      _runQuery()
    setRange: (range) ->
      _clearProducts()
      _setRange range
      _runQuery()

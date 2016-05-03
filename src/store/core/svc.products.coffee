'use strict'

angular.module('store.core').factory 'eeProducts', ($rootScope, $q, $state, $stateParams, $location, eeBootstrap, eeBack, categories) ->

  console.log eeBootstrap

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
    order:        { order: null, title: 'Most relevant' }
    rangeArray: [
      { min: 0,     max: 2500   },
      { min: 2500,  max: 5000   },
      { min: 5000,  max: 10000  },
      { min: 10000, max: 20000  },
      { min: 20000, max: null   }
    ]
    orderArray: [
      { order: null,  title: 'Most relevant' },
      { order: 'pa',  title: 'Price, low to high',  use: true }, # price ASC (pa)
      { order: 'pd',  title: 'Price, high to low',  use: true }, # price DESC (pd)
      { order: 'ta',  title: 'A to Z',              use: true }, # title ASC (ta)
      { order: 'td',  title: 'Z to A',              use: true }  # title DESC (td)
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

  _setRange = (range) ->
    range ||= {}
    if _data.inputs.range.min is range.min and _data.inputs.range.max is range.max
      _data.inputs.range.min = null
      _data.inputs.range.max = null
    else
      _data.inputs.range.min = range.min
      _data.inputs.range.max = range.max

  _setPage = (p) -> _data.inputs.page = p

  _setCategory = (category) ->
    _data.inputs.category = if category? then category else null

  _setSort = (order) ->
    if !order? then order = _data.inputs.orderArray[0]
    _data.inputs.order = order

  _setSearch = (term) ->
    console.log 'term', term
    if term? then _data.inputs.search = term

  _setUrlParams = () ->
    str = if _data.inputs.range?.min? or _data.inputs.range?.max? then [_data.inputs.range.min/100, _data.inputs.range.max/100].join('-') else null
    $stateParams.r = str
    $stateParams.p = _data.inputs.page
    $stateParams.c = _data.inputs.category?.id
    $stateParams.s = _data.inputs.order?.order?.replace(/ /g, '_')
    $stateParams.q = _data.inputs.search
    $location.search 'r', str
    $location.search 'p', _data.inputs.page
    $location.search 'c', _data.inputs.category?.id
    $location.search 's', _data.inputs.order?.order?.replace(/ /g, '_')
    $location.search 'q', _data.inputs.search

  _resetPage = () ->
    _setPage null
    _data.inputs.category = parseInt $stateParams.id

  _formQuery = () ->
    query = {}
    query.size = _data.inputs.perPage
    if _data.inputs.page        then query.page           = _data.inputs.page
    if _data.inputs.size        then query.size           = _data.inputs.size
    if _data.inputs.search      then query.search         = _data.inputs.search
    if _data.inputs.range.min   then query.min_price      = _data.inputs.range.min
    if _data.inputs.range.max   then query.max_price      = _data.inputs.range.max
    if _data.inputs.order.use   then query.order          = _data.inputs.order.order
    if _data.inputs.category    then query.category_ids   = [_data.inputs.category.id]
    if _data.inputs.collection  then query.collection_id  = _data.inputs.collection.id
    query

  _runQuery = () ->
    if _data.reading then return $q.when()
    _data.reading = true
    _setUrlParams()
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
    _setPage null
    _runQuery()

  _searchLike = (term, category_id) ->
    _clearProducts()
    _setPage null
    _setSort null
    _setCategory { id: category_id }
    _data.inputs.search   = term
    _data.inputs.size     = 9
    _runQuery()
    .then () ->
      products = []
      for prod, i in _data.products
        if products.length < 8 and prod.title isnt term then products.push prod
      _data.products = products
      return

  ## MESSAGING
  $rootScope.$on 'reset:page', () -> _resetPage()

  ## EXPORTS
  data: _data
  fns:
    runQuery: _runQuery
    search: _search
    searchLike: _searchLike
    clearSearch: () -> _search ''
    setCategory: (category) ->
      _clearProducts()
      _setPage null
      _setCategory category
      _runQuery()
    setOrder: (order) ->
      _clearProducts()
      _setPage null
      _setSort order
      _runQuery()
    setRange: (range) ->
      _clearProducts()
      _setPage null
      _setRange range
      _runQuery()
    # setPage: (page) ->
    #   _clearProducts()
    #   _setPage page
    #   _runQuery()

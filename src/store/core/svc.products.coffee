'use strict'

angular.module('store.core').factory 'eeProducts', ($rootScope, $q, $state, $stateParams, $location, eeBootstrap, eeBack) ->

  ## SETUP
  _inputDefaults =
    perPage:      eeBootstrap?.perPage
    page:         eeBootstrap?.page
    search:       null
    searchLabel:  null
    range:
      min:        null
      max:        null
    category:     eeBootstrap?.category
    order:        { order: null, title: 'Most relevant' }
    rangeArray: [
      { min: 0,     max: 2500   },
      { min: 2500,  max: 5000   },
      { min: 5000,  max: 10000  },
      { min: 10000, max: 20000  },
      { min: 20000, max: null   }
    ]
    orderArray: [
      { order: null,          title: 'Most relevant' },
      { order: 'price ASC',   title: 'Price, low to high',  use: true },
      { order: 'price DESC',  title: 'Price, high to low',  use: true },
      { order: 'title ASC',   title: 'A to Z',              use: true },
      { order: 'title DESC',  title: 'Z to A',              use: true }
    ]

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

  _resetPage = () ->
    _data.inputs.page = null
    _data.inputs.category = parseInt $stateParams.id
    $stateParams.p = null
    $location.search 'p', null

  _formQuery = () ->
    query = {}
    query.size = _data.inputs.perPage
    if _data.inputs.page        then query.page           = _data.inputs.page
    if _data.inputs.search      then query.search         = _data.inputs.search
    if _data.inputs.range.min   then query.min_price      = _data.inputs.range.min
    if _data.inputs.range.max   then query.max_price      = _data.inputs.range.max
    if _data.inputs.order.use   then query.order          = _data.inputs.order.order
    if _data.inputs.category    then query.category_ids   = [_data.inputs.category]
    if _data.inputs.collection  then query.collection_id  = _data.inputs.collection.id
    query

  _runQuery = () ->
    if _data.reading then return
    _data.reading = true
    eeBack.fns.productsGET _formQuery()
    .then (res) ->
      { rows, count, took } = res
      _data.products      = rows
      _data.count         = count
      _data.took = took
      _data.inputs.searchLabel = _data.inputs.search
    .catch (err) -> _data.count = null
    .finally () -> _data.reading = false

  _search = (term) ->
    _data.inputs.order = _data.inputs.orderArray[0]
    _data.inputs.search = term
    _data.inputs.page = 1
    _runQuery()

  ## MESSAGING
  $rootScope.$on 'reset:page', () -> _resetPage()

  ## EXPORTS
  data: _data
  fns:
    runQuery: _runQuery
    search: _search
    featured: () ->
      _clearProducts()
      _data.inputs.page      = 1
      _data.inputs.featured  = true
      _runQuery()
    clearSearch: () -> _search ''
    setCategory: (id) ->
      _data.inputs.search = null
      # _data.inputs.page = 1
      _data.inputs.category = parseInt(id)
      _runQuery()
    setOrder: (order) ->
      _data.inputs.search  = if !order?.order then _data.inputs.searchLabel else null
      _data.inputs.page    = 1
      _data.inputs.order   = order
      _runQuery()
    setRange: (range) ->
      range = range || {}
      _data.inputs.page = 1
      if _data.inputs.range.min is range.min and _data.inputs.range.max is range.max
        _data.inputs.range.min = null
        _data.inputs.range.max = null
      else
        _data.inputs.range.min = range.min
        _data.inputs.range.max = range.max
      _runQuery()

Sequelize     = require 'sequelize'
sequelize     = require '../config/sequelize/setup'
elasticsearch = require '../config/elasticsearch/setup'
Promise       = require 'bluebird'
_             = require 'lodash'
url           = require 'url'
constants     = require '../server.constants'
utils         = require './utils'

Customization = require './customization'
Collection    = require './collection'
Sku           = require './sku'

Product = sequelize.define 'Product',
  # TODO DRY up this code between ee-back
  title:              type: Sequelize.STRING,   allowNull: false, validate: len: [3,140]
  content:            type: Sequelize.TEXT,     validate: len: [0,5000]
  external_identity:  type: Sequelize.STRING,   allowNull: false
  discontinued:       type: Sequelize.BOOLEAN,  allowNull: false, defaultValue: false
  hide_from_catalog:  type: Sequelize.BOOLEAN,  allowNull: false, defaultValue: false
  image:              type: Sequelize.STRING,   allowNull: false
  additional_images:  type: Sequelize.ARRAY(Sequelize.STRING)
  category_id:        type: Sequelize.INTEGER
  subcategory_id:     type: Sequelize.INTEGER
,
  underscored: true

  classMethods:

    findById: (id) ->
      q =
      'SELECT p.id, p.title, p.image, p.content, p.additional_images, p.category_id, p.discontinued, array_agg(s.regular_price) as regular_prices, array_agg(s.msrp) as msrps
        FROM "Products" p
        JOIN "Skus" s
        ON p.id = s.product_id
        WHERE p.id = ?
        GROUP BY p.id'
      sequelize.query q, { type: sequelize.QueryTypes.SELECT, replacements: [id] }
      .then (products) -> products[0]

    findAllByIds: (ids, opts) ->
      opts ||= {}
      limit  = if opts?.limit  then (' LIMIT '  + parseInt(opts.limit) + ' ') else ' '
      offset = if opts?.offset then (' OFFSET ' + parseInt(opts.offset) + ' ') else ' '
      q =
      'SELECT p.id, p.title, p.image, p.category_id, p.discontinued, array_agg(s.regular_price) as regular_prices, array_agg(s.msrp) as msrps
        FROM "Products" p
        JOIN "Skus" s
        ON p.id = s.product_id
        WHERE p.id IN (' + ids + ')
        GROUP BY p.id
        ORDER BY p.updated_at DESC' + limit + ' ' + offset + ';'
      sequelize.query q, { type: sequelize.QueryTypes.SELECT }

    findCompleteById: (id, seller_id) ->
      scope = {}
      Customization.findAllByProductIds seller_id, [id], null
      .then (customizations) ->
        scope.customizations = customizations
        Product.findById id
      .then (product) -> Sku.addAllToProduct product
      .then (product) -> Customization.alterProducts [product], scope.customizations
      .then (products) -> products[0]

    findAllFeatured: (seller_id, page) ->
      data  = {}
      scope = {}
      Customization.findAllFeatured seller_id, page
      .then (customizations) ->
        if !customizations or customizations.length < 1 then return {}
        scope.customizations = customizations
        product_ids = _.map customizations, 'product_id'
        Product.findAllByIds product_ids
      .then (products) -> Customization.alterProducts products, scope.customizations
      .then (products) ->
        data.rows = products
        Customization.countFeatured seller_id
      .then (res) ->
        data.count = res[0].count
        data

    findAllByCollection: (collection_id, seller_id, page) ->
      perPage = constants.perPage
      page    = if page then parseInt(page) else 1
      offset  = (page - 1) * perPage
      data    = {}
      scope   = {}
      Collection.findById collection_id, seller_id
      .then (rows) ->
        data.collection = rows[0]
        scope.ids = data.collection.product_ids.join(',') || '0'
        Product.findAllByIds scope.ids, { limit: perPage, offset: offset }
      .then (products) ->
        scope.products = products
        Customization.findAllByProductIds seller_id, scope.ids
      .then (customizations) ->
        Customization.alterProducts scope.products, customizations
      .then (products) ->
        data.rows = products
        sequelize.query 'SELECT count(*) FROM "Products" WHERE id IN (' + scope.ids + ')', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
      .then (res) ->
        data.count = res[0].count
        data

    findAllByCategory: (category_id, seller_id, page) ->
      perPage = constants.perPage
      page    = if page then parseInt(page) else 1
      limit   = ' LIMIT ' + constants.perPage + ' '
      offset  = ' OFFSET ' + (page - 1) * perPage + ' '
      data    = {}
      scope   = {}
      q =
      'SELECT p.id, p.title, p.image, p.category_id, p.discontinued, array_agg(s.regular_price) as regular_prices, array_agg(s.msrp) as msrps
        FROM "Products" p
        JOIN "Skus" s
        ON p.id = s.product_id
        WHERE p.category_id = ? AND p.hide_from_catalog = FALSE
        GROUP BY p.id
        ORDER BY p.updated_at DESC' + limit + ' ' + offset + ';'
      sequelize.query q, { type: sequelize.QueryTypes.SELECT, replacements: [parseInt(category_id)] }
      .then (products) ->
        scope.products = products
        product_ids = _.pluck(products, 'id').join(',') || '0'
        Customization.findAllByProductIds seller_id, product_ids
      .then (customizations) ->
        Customization.alterProducts scope.products, customizations
      .then (products) ->
        data.rows = products
        sequelize.query 'SELECT count(*) FROM "Products" WHERE category_id = ? AND hide_from_catalog = FALSE', { type: sequelize.QueryTypes.SELECT, replacements: [parseInt(category_id)] }
      .then (res) ->
        data.count = res[0].count
        data

    ### Below this is adapted from ee-back ----------------------------- ###
    ### TODO DRY up this code! ----------------------------------------- ###

    addCustomizationsFor: (user, products) ->
      if !products or products.length < 1 then return
      product_ids = _.pluck(products, 'id').join(',')
      for product in products
        product.featured  = false
        product.prices    = product.regular_prices
        if product.skus
          product.msrps   = _.pluck product.skus, 'msrp'
          product.prices  = _.pluck product.skus, 'regular_price'
          sku.price = sku.regular_price for sku in product.skus
      sequelize.query 'SELECT product_id, title, featured, selling_prices FROM "Customizations" WHERE seller_id = ? AND product_id IN (' + product_ids + ')', { type: sequelize.QueryTypes.SELECT, replacements: [user.id] }
      # Customization.findAll where: { seller_id: user.id, product_id: $in: product_ids }, attributes: ['product_id'].concat Customization.editable_attrs
      .then (customizations) ->
        Customization.alterProducts products, customizations
        products

    search: (user, opts) ->
      scope = {}

      # Initial body
      body =
        size: opts.size
        filter:
          and: [
            { bool: must_not: term: hide_from_catalog: true },
            { bool: must: has_child: { type: 'sku', filter: { bool: must: range: regular_price: { gte: opts.min_price, lte: opts.max_price } } } }
          ]

      # Pagination
      if opts.size and opts.page then body.from = parseInt(opts.size) * (parseInt(opts.page) - 1)

      # Search
      if opts.search
        body.query =
          fuzzy_like_this:
            fields: ['title', 'content']
            like_text: opts.search
            fuzziness: 1
          # multi_match:
          #   type: 'most_fields'
          #   query: opts.search
          #   fields: ['title', 'content']
        # body.highlight =
        #   pre_tags: ['<strong>']
        #   post_tags: ['</strong>']
        #   fields:
        #     title:
        #       force_source: true
        #       fragment_size: 150
        #       number_of_fragments: 1

      # Categorization
      ids = if opts.category_ids then ('' + opts.category_ids).split(',') else user.categorization_ids
      if ids
        body.filter.and.push({
          bool:
            must:
              terms:
                category_id: ids
        })

      elasticsearch.client.search
        index: 'products_search'
        _source: Product.elasticsearch_findall_attrs
        body: body
      .then (res) ->
        scope.rows    = _.map res?.hits?.hits, '_source'
        scope.count   = res?.hits?.total
        scope.took    = res.took
        scope.page    = opts?.page
        scope.perPage = opts?.size
        Product.addCustomizationsFor user, scope.rows
      .then () ->
        scope

Product.elasticsearch_findall_attrs = [
  'id'
  'title'
  'discontinued'
  'image'
  'category_id'
  'skus'
  # 'msrps'
  # 'regular_prices'
]

module.exports = Product

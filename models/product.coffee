Promise   = require 'bluebird'
_         = require 'lodash'
url       = require 'url'
sequelize = require '../config/sequelize/setup'
constants = require '../server.constants'
utils     = require './utils'

Customization = require './customization'
Collection    = require './collection'
Sku           = require './sku'

Product =

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
    Collection.findAllById collection_id, seller_id
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

module.exports = Product

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

Shared        = require '../copied-from-ee-back/shared'

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

    findById: (id) -> Shared.Product.findById id
      # q =
      # 'SELECT p.id, p.title, p.image, p.content, p.additional_images, p.category_id, p.discontinued, array_agg(s.regular_price) as regular_prices, array_agg(s.msrp) as msrps
      #   FROM "Products" p
      #   JOIN "Skus" s
      #   ON p.id = s.product_id
      #   WHERE p.id = ?
      #   GROUP BY p.id'
      # sequelize.query q, { type: sequelize.QueryTypes.SELECT, replacements: [id] }
      # .then (products) -> products[0]

    findAllByIds: (ids, opts) -> Shared.Product.findAllByIds ids, opts
      # opts ||= {}
      # limit  = if opts?.limit  then (' LIMIT '  + parseInt(opts.limit) + ' ') else ' '
      # offset = if opts?.offset then (' OFFSET ' + parseInt(opts.offset) + ' ') else ' '
      # q =
      # 'SELECT p.id, p.title, p.image, p.category_id, p.discontinued, array_agg(s.regular_price) as regular_prices, array_agg(s.msrp) as msrps
      #   FROM "Products" p
      #   JOIN "Skus" s
      #   ON p.id = s.product_id
      #   WHERE p.id IN (' + ids + ')
      #   GROUP BY p.id
      #   ORDER BY p.updated_at DESC' + limit + ' ' + offset + ';' # ORDER BY needs to match ee-back for consistent sorting
      # sequelize.query q, { type: sequelize.QueryTypes.SELECT }

    findCompleteById: (id, seller_id) ->
      scope = {}
      Customization.findAllByProductIds seller_id, [id], null
      .then (customizations) ->
        scope.customizations = customizations
        Shared.Product.findById id
      .then (product) -> Sku.addAllToProduct product
      .then (product) -> Customization.alterProducts [product], scope.customizations
      .then (products) -> products[0]

    # findAllFeatured: (seller_id, page) ->
    #   data  = {}
    #   scope = {}
    #   Customization.findAllFeatured seller_id, page
    #   .then (customizations) ->
    #     if !customizations or customizations.length < 1 then return {}
    #     scope.customizations = customizations
    #     product_ids = _.map customizations, 'product_id'
    #     Shared.Product.findAllByIds product_ids
    #   .then (products) -> Customization.alterProducts products, scope.customizations
    #   .then (products) ->
    #     data.rows = products
    #     Customization.countFeatured seller_id
    #   .then (res) ->
    #     data.count = res[0].count
    #     data

    findAllByCollection: (user, opts) ->
      Collection.findById opts.collection_id, user.id
      .then (rows) -> Shared.Collection.formattedResponse rows[0], user, opts

    search: (user, opts) -> Shared.Product.search user, opts
    sort: (user, opts) -> Shared.Product.sort user, opts
    addCustomizationsFor: (user, products) -> Shared.Product.addCustomizationsFor user, products
    # addAdminDetailsFor: (user, products) -> Shared.Product.addAdminDetailsFor user, products

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

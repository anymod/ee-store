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

    findAllByIds: (ids, opts) -> Shared.Product.findAllByIds ids, opts

    findCompleteById: (id, user) ->
      scope = {}
      Customization.findAllByProductIds user.id, [id], null
      .then (customizations) ->
        scope.customizations = customizations
        Shared.Product.findById id
      .then (product) ->
        scope.product = product
        Sku.addAllToProduct scope.product
      .then () -> Customization.alterProducts [scope.product], scope.customizations
      .then () ->
        Shared.Sku.setPricesFor scope.product.skus, user.pricing
        scope.product

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

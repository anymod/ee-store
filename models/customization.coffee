Promise   = require 'bluebird'
_         = require 'lodash'
url       = require 'url'
sequelize = require '../config/sequelize/setup'
constants = require '../server.constants'
utils     = require './utils'

Customization =

  findAllFeatured: (seller_id, page) ->
    perPage = constants.perPage
    page  ||= 1
    offset  = (page - 1) * perPage
    sequelize.query 'SELECT id, product_id, title, featured, selling_prices FROM "Customizations" WHERE seller_id = ? AND featured = true ORDER BY updated_at DESC LIMIT ? OFFSET ?', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id, perPage, offset] }

  countFeatured: (seller_id) ->
    sequelize.query 'SELECT count(*) FROM "Customizations" WHERE seller_id = ? AND featured = true', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }

  findAllByProductIds: (seller_id, product_ids, page) ->
    perPage       = constants.perPage
    page        ||= 1
    offset        = (page - 1) * perPage
    product_ids ||= '0'
    sequelize.query 'SELECT id, product_id, title, featured, selling_prices FROM "Customizations" WHERE seller_id = ? AND product_id IN (' + product_ids + ') ORDER BY updated_at DESC LIMIT ? OFFSET ?', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id, perPage, offset] }

  # findByProductId: (seller_id, product_id) ->
  #   Customization.findAllByProductIds seller_id, [product_id]
  #   .then (customizations) -> customizations[0]

  countByProductIds: (seller_id, product_ids) ->
    sequelize.query 'SELECT count(*) FROM "Customizations" WHERE seller_id = ? AND product_id IN (' + product_ids + ')', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }

  alterProducts: (products, customizations) ->
    if !products or products.length < 1 then return
    product_ids = _.pluck products, 'id'
    for product in products
      product.featured  = false
      product.prices    = product.regular_prices
      if product.skus
        product.msrps   = _.pluck product.skus, 'msrp'
        product.prices  = _.pluck product.skus, 'regular_price'
        sku.price = sku.regular_price for sku in product.skus
      for customization in customizations
        if customization.product_id is product.id
          if product.skus then Customization.alterSkus product.skus, customization
          Customization.alterProduct product, customization
      if !product.skus then product.skus = null
    # TODO return prices and msrps in order
    products

  alterSkus: (skus, customization) ->
    for sku in skus
      if customization?.selling_prices
        res = _.where customization.selling_prices, { sku_id: sku.id }
        sku.price = if res and res.length > 0 then res[0].selling_price else sku.regular_price
      else
        sku.price = sku.regular_price
    customization

  alterProduct: (product, customization) ->
    if customization?.title then product.title = customization.title
    product.featured = !!customization?.featured
    if customization.selling_prices and customization.selling_prices.length > 0 then product.prices = _.map customization.selling_prices, 'selling_price'
    if product.skus
      product.msrps = _.pluck product.skus, 'msrp'
      product.prices = _.pluck product.skus, 'price'
    customization

module.exports = Customization

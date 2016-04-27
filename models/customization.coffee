Promise   = require 'bluebird'
_         = require 'lodash'
url       = require 'url'
sequelize = require '../config/sequelize/setup'
constants = require '../server.constants'
utils     = require './utils'

Shared = require '../copied-from-ee-back/shared'

Customization =

  findAllByProductIds: (seller_id, product_ids, page) ->
    perPage       = constants.perPage
    page        ||= 1
    offset        = (page - 1) * perPage
    product_ids ||= '0'
    sequelize.query 'SELECT id, product_id, title FROM "Customizations" WHERE seller_id = ? AND product_id IN (' + product_ids + ') ORDER BY updated_at DESC LIMIT ? OFFSET ?', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id, perPage, offset] }

  countByProductIds: (seller_id, product_ids) ->
    sequelize.query 'SELECT count(*) FROM "Customizations" WHERE seller_id = ? AND product_id IN (' + product_ids + ')', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }

  alterProducts: (products, customizations) ->
    if !products or products.length < 1 then return
    for product in products
      Shared.Customization.alterProduct product, customizations
    # # TODO return prices and msrps in order
    # products

  alterProduct: (product, customizations) ->
    customizations ||= []
    for customization in customizations
      if customization.product_id is product.id
        Shared.Customization.alterProduct product, customization
    product

module.exports = Customization

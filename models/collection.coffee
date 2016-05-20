Promise   = require 'bluebird'
_         = require 'lodash'
url       = require 'url'
sequelize = require '../config/sequelize/setup'
constants = require '../server.constants'
utils     = require './utils'

Shared    = require '../copied-from-ee-back/shared'

### IMPORTANT ###
# Users, Collections, and Orders should use
# 'deleted_at IS NULL' as part of query

Collection =

  findAll: (seller_id) ->
    sequelize.query 'SELECT id, banner, updated_at FROM "Collections" WHERE seller_id = ? AND banner NOT ILIKE \'%white.jpg%\' AND deleted_at IS NULL ORDER BY updated_at DESC LIMIT 48', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
    .then (collections) -> collections

  # navCollectionsBySellerId: (seller_id) ->
  #   data = {}
  #   sequelize.query 'SELECT id, title, headline, button, banner FROM "Collections" WHERE seller_id = ? AND banner NOT ILIKE \'%white.jpg%\' AND deleted_at IS NULL ORDER BY updated_at DESC LIMIT 10', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
  #   .then (collections) -> collections

  findById: (collection_id, seller_id) ->
    sequelize.query 'SELECT id, title, headline, banner, seller_id, product_ids FROM "Collections" WHERE id = ? AND seller_id = ? AND deleted_at IS NULL', { type: sequelize.QueryTypes.SELECT, replacements: [collection_id, seller_id] }

  findSaleBySellerId: (seller_id) ->
    sequelize.query 'SELECT id, title, headline, banner, seller_id, product_ids FROM "Collections" WHERE seller_id = ? AND discount_sale_section IS true AND deleted_at IS NULL ORDER BY updated_at DESC LIMIT 1', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
    .then (collections) -> collections[0]

  findHomeCarousel: Shared.Collection.findHomeCarousel
    # collection_ids ||= '0'
    # sequelize.query 'SELECT id, banner FROM "Collections" WHERE id IN (' + collection_ids + ') AND banner IS NOT NULL AND show_banner IS TRUE AND seller_id = ? AND deleted_at IS NULL', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
    # .then (collections) -> utils.orderedResults collections, collection_ids.split(',')

  findHomeArranged: Shared.Collection.findHomeArranged
    # collection_ids ||= '0'
    # arranged = []
    # sequelize.query 'SELECT id, banner, show_banner, product_ids FROM "Collections" WHERE id IN (' + collection_ids + ') AND seller_id = ? AND deleted_at IS NULL', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
    # .then (collections) ->
    #   addProductsIfNoBanner = (collection) ->
    #     return if !collection.product_ids or collection.product_ids.length < 1
    #     if collection.banner and collection.show_banner
    #       delete collection.product_ids
    #       return arranged.push collection
    #     Shared.Collection.formattedResponse collection, { id: seller_id }, { size: 8 }
    #     .then (coll) ->
    #       delete collection.product_ids
    #       collection.products = coll.rows
    #       arranged.push collection
    #   Promise.reduce collections, ((total, collection) -> addProductsIfNoBanner collection), 0
    # .then () -> utils.orderedResults arranged, collection_ids.split(',')

  metaImagesFor: (seller_id) ->
    sequelize.query 'SELECT banner FROM "Collections" WHERE seller_id = ? AND banner IS NOT NULL AND deleted_at IS NULL ORDER BY updated_at DESC LIMIT 5', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
    .then (images) ->
      _.pluck images, 'banner'

module.exports = Collection

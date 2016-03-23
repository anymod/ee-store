Promise   = require 'bluebird'
_         = require 'lodash'
url       = require 'url'
sequelize = require '../config/sequelize/setup'
constants = require '../server.constants'
utils     = require './utils'

### IMPORTANT ###
# Users, Collections, and Orders should use
# 'deleted_at IS NULL' as part of query

Collection =

  findAll: (seller_id) ->
    sequelize.query 'SELECT id, banner, updated_at, in_carousel FROM "Collections" WHERE seller_id = ? AND banner NOT ILIKE \'%white.jpg%\' AND deleted_at IS NULL ORDER BY updated_at DESC LIMIT 48', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
    .then (collections) -> collections

  # navCollectionsBySellerId: (seller_id) ->
  #   data = {}
  #   sequelize.query 'SELECT id, title, headline, button, banner, in_carousel FROM "Collections" WHERE seller_id = ? AND in_carousel = true AND banner NOT ILIKE \'%white.jpg%\' AND deleted_at IS NULL ORDER BY updated_at DESC LIMIT 10', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
  #   .then (collections) -> collections

  findById: (collection_id, seller_id) ->
    sequelize.query 'SELECT id, title, headline, banner, seller_id, product_ids FROM "Collections" WHERE id = ? AND seller_id = ? AND deleted_at IS NULL', { type: sequelize.QueryTypes.SELECT, replacements: [collection_id, seller_id] }

  # findByIds: (collection_ids, seller_id) ->
  #   collection_ids ||= '0'
  #   sequelize.query 'SELECT id, banner, show_banner, product_ids FROM "Collections" WHERE id IN (' + collection_ids + ') AND seller_id = ? AND deleted_at IS NULL', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }

  findHomeCarousel: (collection_ids, seller_id) ->
    collection_ids ||= '0'
    sequelize.query 'SELECT id, banner FROM "Collections" WHERE id IN (' + collection_ids + ') AND banner IS NOT NULL AND show_banner IS TRUE AND seller_id = ? AND deleted_at IS NULL', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
    .then (collections) -> utils.orderedResults collections, collection_ids.split(',')

  findHomeArranged: (collection_ids, seller_id) ->
    Collection.findByIds collection_ids, seller_id
    .then (collections) ->
      console.log 'findHomeArranged', collections
      collections

  metaImagesFor: (seller_id) ->
    sequelize.query 'SELECT banner FROM "Collections" WHERE seller_id = ? AND in_carousel IS true AND banner IS NOT NULL AND deleted_at IS NULL ORDER BY updated_at DESC LIMIT 5', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
    .then (images) ->
      _.pluck images, 'banner'

module.exports = Collection

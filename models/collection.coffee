Promise   = require 'bluebird'
_         = require 'lodash'
url       = require 'url'
sequelize = require '../config/sequelize/setup'
constants = require '../server.constants'
utils     = require './utils'

Collection =

  navCollectionsBySellerId: (seller_id) ->
    data = {}
    sequelize.query 'SELECT id, title, headline, button, banner, in_carousel FROM "Collections" WHERE seller_id = ? AND in_carousel = true AND title IS NOT null AND banner NOT ILIKE \'%placehold.it%\' AND deleted_at IS NULL ORDER BY updated_at DESC LIMIT 10', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
    .then (collections) ->
      data.carousel = collections
      sequelize.query 'SELECT id, title FROM "Collections" WHERE seller_id = ? AND title IS NOT null AND deleted_at IS NULL ORDER BY title ASC LIMIT 100', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
    .then (collections) ->
      data.alphabetical = collections
      data

  findAllById: (collection_id, seller_id) ->
    sequelize.query 'SELECT id, title, headline, banner, seller_id, product_ids FROM "Collections" WHERE id = ? AND seller_id = ? AND deleted_at IS NULL', { type: sequelize.QueryTypes.SELECT, replacements: [collection_id, seller_id] }

module.exports = Collection

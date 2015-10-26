Promise   = require 'bluebird'
_         = require 'lodash'
url       = require 'url'
sequelize = require './config/sequelize/setup'
constants = require './server.constants'

f = {}

### IMPORTANT ###
# Users, Collections, and Orders should use
# 'deleted_at IS NULL' as part of query

f.storeByUsername = (username) -> sequelize.query 'SELECT id, username, storefront_meta, collections FROM "Users" WHERE username = ? AND deleted_at IS NULL', { type: sequelize.QueryTypes.SELECT, replacements: [username] }
f.storeByDomain   = (host) -> sequelize.query 'SELECT id, username, storefront_meta, collections FROM "Users" WHERE domain = ? AND deleted_at IS NULL', { type: sequelize.QueryTypes.SELECT, replacements: [host] }

f.collectionsBySellerId = (seller_id) -> sequelize.query 'SELECT id, title, headline, button, banner, in_carousel FROM "Collections" WHERE seller_id = ? AND deleted_at IS null ORDER BY updated_at DESC', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
f.navCollectionsBySellerId = (seller_id) ->
  data = {}
  sequelize.query 'SELECT id, title, headline, button, banner, in_carousel FROM "Collections" WHERE seller_id = ? AND in_carousel = true AND title IS NOT null AND banner NOT ILIKE \'%placehold.it%\' AND deleted_at IS NULL ORDER BY updated_at DESC LIMIT 10', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
  .then (collections) ->
    data.carousel = collections
    sequelize.query 'SELECT id, title FROM "Collections" WHERE seller_id = ? AND title IS NOT null AND deleted_at IS NULL ORDER BY title ASC LIMIT 100', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
  .then (collections) ->
    data.alphabetical = collections
    data

f.featuredProducts = (seller_id, page) ->
  perPage = constants.perPage
  page  ||= 1
  offset  = (page - 1) * perPage
  data    = {}
  sequelize.query 'SELECT id, title, selling_price, image, msrp FROM "Products" WHERE seller_id = ? AND featured = true ORDER BY updated_at DESC LIMIT ? OFFSET ?', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id, perPage, offset] }
  .then (products) ->
    data.rows = products
    sequelize.query 'SELECT count(*) FROM "Products" WHERE seller_id = ? AND featured = true', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
  .then (res) ->
    data.count = res[0].count
    data

# f.selectionsByFeatured    = (seller_id, page) ->
#   perPage = constants.perPage
#   page  ||= 1
#   offset  = (page - 1) * perPage
#   data    = {}
#   sequelize.query 'SELECT id, title, selling_price, image, collection, discontinued, out_of_stock, msrp FROM "Selections" WHERE seller_id = ? AND featured = true LIMIT ? OFFSET ?', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id, perPage, offset] }
#   .then (selections) ->
#     data.rows = selections
#     sequelize.query 'SELECT count(*) FROM "Selections" WHERE seller_id = ? AND featured = true', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
#   .then (res) ->
#     data.count = res[0].count
#     data
#
# f.selectionsByCollection  = (seller_id, collection, page) ->
#   perPage = constants.perPage
#   page  ||= 1
#   offset  = (page - 1) * perPage
#   data    = {}
#   sequelize.query 'SELECT id, title, selling_price, image, collection, discontinued, out_of_stock, msrp FROM "Selections" WHERE seller_id = ? AND collection = ? LIMIT ? OFFSET ?', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id, collection, perPage, offset] }
#   .then (selections) ->
#     data.rows = selections
#     sequelize.query 'SELECT count(*) FROM "Selections" WHERE seller_id = ? AND collection = ?', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id, collection] }
#   .then (res) ->
#     data.count = res[0].count
#     data


f.productByIds   = (product_id, seller_id) -> sequelize.query 'SELECT id, title, selling_price, image, additional_images, content, discontinued, out_of_stock, featured, template_id, msrp FROM "Products" WHERE id = ? AND seller_id = ?', { type: sequelize.QueryTypes.SELECT, replacements: [product_id, seller_id] }
f.productsByIds  = (id_string, seller_id) -> sequelize.query ('SELECT id, title, selling_price, image, additional_images, content, discontinued, out_of_stock, featured, template_id, msrp FROM "Products" WHERE id in (' + id_string + ') AND seller_id = ?'), { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
f.productsInCollection = (collection_id, seller_id, page) ->
  perPage = constants.perPage
  page  ||= 1
  offset  = (page - 1) * perPage
  data    = {}
  sequelize.query 'SELECT id, title, headline, banner, seller_id, template_ids FROM "Collections" WHERE id = ? AND seller_id = ? AND deleted_at IS NULL', { type: sequelize.QueryTypes.SELECT, replacements: [collection_id, seller_id] }
  .then (rows) ->
    data.collection = rows[0]
    data.id_string  = data.collection.template_ids.join(',') || '0'
    sequelize.query 'SELECT id, title, selling_price, image, additional_images, content, discontinued, out_of_stock, featured, template_id, msrp FROM "Products" WHERE template_id IN (' + data.id_string + ') AND seller_id = ? LIMIT ? OFFSET ?', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id, perPage, offset] }
  .then (products) ->
    data.rows = products
    sequelize.query 'SELECT count(*) FROM "Products" WHERE template_id IN (' + data.id_string + ') AND seller_id = ?', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
  .then (res) ->
    data.count = res[0].count
    data
f.productsForCart = (id_string, seller_id) ->
  productArray = []
  f.productsByIds id_string, seller_id
  .then (products) ->
    addCartInfo = (product) ->
      f.templateById product.template_id
      .then (template) ->
        product.shipping_price = template[0].shipping_price
        productArray.push product
    Promise.reduce products, ((total, product) -> addCartInfo product), 0
  .then () -> productArray

f.templateById = (template_id) -> sequelize.query 'SELECT id, title, content, content_meta, availability_meta, shipping_price, discontinued, out_of_stock, quantity, regular_price, msrp FROM "Templates" where id = ?', { type: sequelize.QueryTypes.SELECT, replacements: [template_id] }

f.cartByIdAndUuid = (cart_id, uuid) -> sequelize.query 'SELECT quantity_array FROM "Carts" WHERE id = ? AND uuid = ?', { type: sequelize.QueryTypes.SELECT, replacements: [cart_id, uuid] }

f.userByHost = (host) ->
  host  = host.replace 'www.', ''
  searchTerm  = host
  queryUser   = f.storeByDomain
  if process.env.NODE_ENV isnt 'production' or host.indexOf('eeosk.com') > -1 or host.indexOf('herokuapp.com') > -1 or host.indexOf('.demoseller.com') > -1
    username = 'demoseller'
    if host.indexOf('herokuapp.com') > -1 then username = 'demoseller' # 'agarrett'
    if host.indexOf('eeosk.com') > -1 or host.indexOf('.demoseller.com') > -1 then username = host.split('.')[0]
    searchTerm  = username
    queryUser   = f.storeByUsername
  queryUser searchTerm

module.exports = f

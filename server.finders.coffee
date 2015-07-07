_         = require 'lodash'
url       = require 'url'
sequelize = require './config/sequelize/setup'

f = {}

f.storeByUsername = (username) -> sequelize.query 'SELECT id, username, storefront_meta, collections FROM "Users" WHERE username = ?', { type: sequelize.QueryTypes.SELECT, replacements: [username] }
f.storeByDomain   = (host) -> sequelize.query 'SELECT id, username, storefront_meta, collections FROM "Users" WHERE domain = ?', { type: sequelize.QueryTypes.SELECT, replacements: [host] }

f.selectionsByFeatured    = (seller_id) -> sequelize.query 'SELECT id, title, selling_price, image, collection FROM "Selections" WHERE seller_id = ? AND featured = true', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
f.selectionsByCollection  = (seller_id, collection) -> sequelize.query 'SELECT id, title, selling_price, image, collection FROM "Selections" WHERE seller_id = ? AND collection = ?', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id, collection] }
f.selectionByIds          = (selection_id, seller_id) -> sequelize.query 'SELECT id, title, selling_price, image, collection, content, discontinued, out_of_stock, quantity, featured, product_meta FROM "Selections" WHERE id = ? AND seller_id = ?', { type: sequelize.QueryTypes.SELECT, replacements: [selection_id, seller_id] }
f.selectionsByIds         = (id_string, seller_id) -> sequelize.query ('SELECT id, title, selling_price, image, collection, content, discontinued, out_of_stock, quantity, featured, product_meta FROM "Selections" WHERE id in (' + id_string + ') AND seller_id = ?'), { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }

f.cartByIdAndUuid = (cart_id, uuid) -> sequelize.query 'SELECT quantity_array FROM "Carts" WHERE id = ? AND uuid = ?', { type: sequelize.QueryTypes.SELECT, replacements: [cart_id, uuid] }

f.userByHost = (host) ->
  host  = host.replace 'www.', ''
  searchTerm  = host
  queryUser   = f.storeByDomain
  if process.env.NODE_ENV isnt 'production' or host.indexOf('eeosk.com') > -1 or host.indexOf('herokuapp.com') > -1
    username = 'demoseller'
    if host.indexOf('eeosk.com') > -1 then username = host.split('.')[0]
    searchTerm  = username
    queryUser   = f.storeByUsername
  queryUser searchTerm

module.exports = f

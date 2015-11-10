# Promise   = require 'bluebird'
# _         = require 'lodash'
# url       = require 'url'
# sequelize = require './config/sequelize/setup'
# constants = require './server.constants'
#
# f = {}
#
# ### IMPORTANT ###
# # Users, Collections, and Orders should use
# # 'deleted_at IS NULL' as part of query
#
# # f.collectionsBySellerId = (seller_id) -> sequelize.query 'SELECT id, title, headline, button, banner, in_carousel FROM "Collections" WHERE seller_id = ? AND deleted_at IS null ORDER BY updated_at DESC', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
#
# # f.productsForCart = (id_string, seller_id) ->
# #   productArray = []
# #   f.productsByIds id_string, seller_id
# #   .then (products) ->
# #     addCartInfo = (product) ->
# #       f.templateById product.template_id
# #       .then (template) ->
# #         product.shipping_price = template[0].shipping_price
# #         productArray.push product
# #     Promise.reduce products, ((total, product) -> addCartInfo product), 0
# #   .then () -> productArray
#
# # f.templateById = (template_id) -> sequelize.query 'SELECT id, title, content, content_meta, availability_meta, shipping_price, discontinued, out_of_stock, quantity, regular_price, msrp FROM "Templates" where id = ?', { type: sequelize.QueryTypes.SELECT, replacements: [template_id] }
#
# module.exports = f

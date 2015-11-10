Promise   = require 'bluebird'
_         = require 'lodash'
url       = require 'url'
sequelize = require '../config/sequelize/setup'
constants = require '../server.constants'
utils     = require './utils'

Cart =

  findByIdAndUuid: (cart_id, uuid) ->
    sequelize.query 'SELECT quantity_array FROM "Carts" WHERE id = ? AND uuid = ?', { type: sequelize.QueryTypes.SELECT, replacements: [cart_id, uuid] }

module.exports = Cart

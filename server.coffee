switch process.env.NODE_ENV
  when 'production'
    require 'newrelic'
  when 'test'
    process.env.PORT = 4444
  else
    process.env.NODE_ENV = 'development'
    process.env.PORT = 4000

express       = require 'express'
morgan        = require 'morgan'
path          = require 'path'
serveStatic   = require 'serve-static'
cookieParser  = require 'cookie-parser'
ejs           = require 'ejs'
url           = require 'url'
Promise       = require 'bluebird'
_             = require 'lodash'
sequelize     = require './config/sequelize/setup'

app = express()
app.set 'view engine', 'ejs'
app.set 'views', path.join __dirname, 'dist'

if process.env.NODE_ENV is 'production' then app.use morgan 'common' else app.use morgan 'dev'

app.use serveStatic(path.join __dirname, 'dist')
app.use cookieParser()

setup = (req) ->
  {
    bootstrap:
      cart: req.cart
      url: req.headers.host + req.url
    host: req.headers.host
    path: url.parse(req.url).pathname
  }

assignBootstrap = (bootstrap, attrs) ->
  bootstrap.first_load        = true
  bootstrap.username          = attrs.username
  bootstrap.storefront_meta   = attrs.storefront_meta
  bootstrap.collections       = attrs.collections
  bootstrap.collection_names  = collectionNames attrs.collections
  bootstrap.title             = attrs.storefront_meta?.home?.name
  bootstrap.site_name         = attrs.storefront_meta?.home?.name
  bootstrap

storeByUsername = (username) -> sequelize.query 'SELECT id, username, storefront_meta, collections FROM "Users" WHERE username = ?', { type: sequelize.QueryTypes.SELECT, replacements: [username] }
storeByDomain   = (host) -> sequelize.query 'SELECT id, username, storefront_meta, collections FROM "Users" WHERE domain = ?', { type: sequelize.QueryTypes.SELECT, replacements: [host] }

selectionsByFeatured    = (seller_id) -> sequelize.query 'SELECT id, title, selling_price, image, collection FROM "Selections" WHERE seller_id = ? AND featured = true', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
selectionsByCollection  = (seller_id, collection) -> sequelize.query 'SELECT id, title, selling_price, image, collection FROM "Selections" WHERE seller_id = ? AND collection = ?', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id, collection] }
selectionByIds          = (selection_id, seller_id) -> sequelize.query 'SELECT id, title, selling_price, image, collection, content, discontinued, out_of_stock, quantity, featured, product_meta FROM "Selections" WHERE id = ? AND seller_id = ?', { type: sequelize.QueryTypes.SELECT, replacements: [selection_id, seller_id] }
selectionsByIds         = (id_string, seller_id) -> sequelize.query ('SELECT id, title, selling_price, image, collection, content, discontinued, out_of_stock, quantity, featured, product_meta FROM "Selections" WHERE id in (' + id_string + ') AND seller_id = ?'), { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }

cartByIdAndUuid = (cart_id, uuid) -> sequelize.query 'SELECT quantity_array FROM "Carts" WHERE id = ? AND uuid = ?', { type: sequelize.QueryTypes.SELECT, replacements: [cart_id, uuid] }

collectionNames = (collections) ->
  collections ||= {}
  names = ['featured']
  names.push name for name in Object.keys(collections)
  _.uniq names

findUserByHost = (host) ->
  host  = host.replace 'www.', ''
  if process.env.NODE_ENV isnt 'production' or host.indexOf('eeosk.com') > -1 or host.indexOf('herokuapp.com') > -1
    username = 'demoseller'
    if host.indexOf('eeosk.com') > -1 then username = host.split('.')[0]
    searchTerm  = username
    queryUser   = storeByUsername
  else
    searchTerm  = host
    queryUser   = storeByDomain
  queryUser searchTerm

String.prototype.escapeSpecialChars = () ->
  this.replace /&#34;/g,'"'
    .replace /\\n/g, "\\n"
    .replace /\\'/g, "\\'"
    .replace /\\"/g, '\\"'
    .replace /\\&/g, "\\&"
    .replace /\\r/g, "\\r"
    .replace /\\t/g, "\\t"
    .replace /\\b/g, "\\b"
    .replace /\\f/g, "\\f"

cartCookie = (req, res, next) ->
  if req.cookies and req.cookies.cart
    [ee, cart_id, uuid] = req.cookies.cart.split('.')
    if !cart_id or !uuid then return next()
    cartByIdAndUuid cart_id, uuid
    .then (data) -> req.cart = data[0]
    .catch (err) -> console.log 'Error in cartCookie', err
    .finally () -> next()
  else
    next()

app.use cartCookie


# FEATURED (TODO give ABOUT its own route)
app.get ['/', '/featured', '/shop/featured', '/about'], (req, res, next) ->
  { bootstrap, host, path } = setup req
  findUserByHost host
  .then (data) ->
    assignBootstrap bootstrap, data[0]
    selectionsByFeatured data[0].id
  .then (selections) ->
    # TODO add pagination
    bootstrap.selections = selections
    bootstrap.stringified = JSON.stringify(bootstrap).escapeSpecialChars()
    res.render 'store.ejs', { bootstrap: bootstrap }
  .catch (err) ->
    # TODO add better error pages
    console.error 'error in FEATURED', err
    res.send 'Not found'

# COLLECTIONS
app.get ['/shop/:collection'], (req, res, next) ->
  { bootstrap, host, path } = setup req
  collection = path.split('shop/')[1].replace(/[^\w]/gi, '_').toLowerCase()
  findUserByHost host
  .then (data) ->
    assignBootstrap bootstrap, data[0]
    selectionsByCollection data[0].id, collection
  .then (selections) ->
    # TODO add pagination
    bootstrap.selections = selections
    bootstrap.stringified = JSON.stringify(bootstrap).escapeSpecialChars()
    res.render 'store.ejs', { bootstrap: bootstrap }
  .catch (err) ->
    console.error 'error in COLLECTIONS', err
    res.send 'Not found'

# SELECTIONS
app.get '/selections/:id/:slug', (req, res, next) ->
  { bootstrap, host, path } = setup req
  findUserByHost host
  .then (data) ->
    assignBootstrap bootstrap, data[0]
    selectionByIds req.params.id, data[0].id
  .then (selection) ->
    bootstrap.title = selection[0].title
    bootstrap.description = selection[0].content
    bootstrap.selection = selection[0]
    bootstrap.stringified = JSON.stringify(bootstrap).escapeSpecialChars()
    res.render 'store.ejs', { bootstrap: bootstrap }
  .catch (err) ->
    console.error 'error in SELECTIONS', err
    res.send 'Not found'

app.get '/cart', (req, res, next) ->
  { bootstrap, host, path } = setup req
  findUserByHost host
  .then (data) ->
    assignBootstrap bootstrap, data[0]
    if req.cart and req.cart.quantity_array and req.cart.quantity_array.length > 0
      selection_ids = _.pluck req.cart.quantity_array, 'id'
      selectionsByIds selection_ids.join(','), data[0].id
      .then (data) -> bootstrap.cart.selections = data
      .finally () ->
        bootstrap.stringified = JSON.stringify(bootstrap).escapeSpecialChars()
        res.render 'store.ejs', { bootstrap: bootstrap }
    else
      bootstrap.stringified = JSON.stringify(bootstrap).escapeSpecialChars()
      res.render 'store.ejs', { bootstrap: bootstrap }

app.listen process.env.PORT, ->
  console.log 'Store app listening on port ' + process.env.PORT
  return

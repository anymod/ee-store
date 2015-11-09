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
compression   = require 'compression'
_             = require 'lodash'
constants     = require './server.constants'
finders       = require './server.finders'
helpers       = require './server.helpers'
utils         = require './models/utils'

User          = require './models/user'
Product       = require './models/product'

app = express()
app.use compression()

app.set 'view engine', 'ejs'
app.set 'views', path.join __dirname, 'dist'

if process.env.NODE_ENV is 'production' then app.use morgan 'common' else app.use morgan 'dev'

app.use serveStatic(path.join __dirname, 'dist')
app.use cookieParser()

cartCookie = (req, res, next) ->
  if req.cookies and req.cookies.cart
    [ee, cart_id, uuid] = req.cookies.cart.split('.')
    if !cart_id or !uuid then return next()
    finders.cartByIdAndUuid cart_id, uuid
    .then (data) -> req.cart = data[0]
    .catch (err) -> console.log 'Error in cartCookie', err
    .finally () -> next()
  else
    next()

app.use cartCookie

# HOME
app.get '/', (req, res, next) ->
  { bootstrap, host, path } = helpers.setup req
  User.defineStorefront host, bootstrap
  .then () -> Product.findAllFeatured bootstrap.id, bootstrap.page
  .then (data) ->
    { rows, count } = data
    bootstrap.products    = rows || []
    bootstrap.count       = count
    bootstrap.stringified = utils.stringify bootstrap
    res.render 'store.ejs', { bootstrap: bootstrap }
  .catch (err) ->
    # TODO add better error pages
    console.error 'error in HOME', err
    res.send 'Not found'

# ABOUT
app.get ['/about'], (req, res, next) ->
  { bootstrap, host, path } = helpers.setup req
  User.defineStorefront host, bootstrap
  .then () ->
    bootstrap.stringified = utils.stringify bootstrap
    res.render 'store.ejs', { bootstrap: bootstrap }
  .catch (err) ->
    # TODO add better error pages
    console.error 'error in ABOUT', err
    res.redirect '/'

# COLLECTIONS
app.get '/collections/:id/:title*?', (req, res, next) ->
  { bootstrap, host, path } = helpers.setup req
  User.defineStorefront host, bootstrap
  .then () -> Product.findAllByCollection req.params.id, bootstrap.id, bootstrap.page
  .then (data) ->
    { collection, rows, count } = data
    bootstrap.collection    = collection
    bootstrap.products      = rows || []
    bootstrap.count         = count
    bootstrap.title         = utils.formCollectionPageTitle bootstrap.collection.title, bootstrap.title
    bootstrap.images        = utils.makeMetaImages(_.pluck(bootstrap.products.slice(0,3), 'image'))
    bootstrap.stringified   = utils.stringify bootstrap
    res.render 'store.ejs', { bootstrap: bootstrap }
  .catch (err) ->
    console.error 'error in COLLECTIONS', err
    res.redirect '/'

# PRODUCTS
app.get '/products/:id/:title*?', (req, res, next) ->
  { bootstrap, host, path } = helpers.setup req
  User.defineStorefront host, bootstrap
  .then () -> Product.findCompleteById req.params.id, bootstrap.id
  .then (product) ->
    bootstrap.product     = product
    bootstrap.title       = bootstrap.product.title
    bootstrap.images      = utils.makeMetaImages([ bootstrap.product?.image ])
    bootstrap.description = bootstrap.product.content
    bootstrap.stringified = utils.stringify bootstrap
    res.render 'store.ejs', { bootstrap: bootstrap }
  .catch (err) ->
    console.error 'error in PRODUCTS', err
    res.redirect '/'

# CART
app.get '/cart', (req, res, next) ->
  { bootstrap, host, path } = helpers.setup req
  helpers.defineStorefront host, bootstrap
  .then () ->
    if req.cart and req.cart.quantity_array and req.cart.quantity_array.length > 0
      product_ids = _.pluck req.cart.quantity_array, 'id'
      finders.productsForCart product_ids.join(','), bootstrap.id
      .then (data) -> bootstrap.cart.products = data
      .finally () ->
        bootstrap.stringified = utils.stringify bootstrap
        res.render 'store.ejs', { bootstrap: bootstrap }
    else
      bootstrap.stringified = utils.stringify bootstrap
      res.render 'store.ejs', { bootstrap: bootstrap }
  .catch (err) ->
    console.error 'error in CART', err
    res.redirect '/'

# LEGACY REDIRECTS
app.get ['/selections/:id/:title', '/shop', '/shop/:title'], (req, res, next) ->
  res.redirect '/'

app.listen process.env.PORT, ->
  console.log 'Store app listening on port ' + process.env.PORT
  return

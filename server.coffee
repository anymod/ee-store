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
_             = require 'lodash'
finders       = require './server.finders'
helpers       = require './server.helpers'

app = express()
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

# FEATURED (TODO give ABOUT its own route)
app.get ['/', '/featured', '/shop/featured', '/about'], (req, res, next) ->
  { bootstrap, host, path } = helpers.setup req
  finders.userByHost host
  .then (data) ->
    helpers.assignBootstrap bootstrap, data[0]
    finders.selectionsByFeatured data[0].id
  .then (selections) ->
    # TODO add pagination
    bootstrap.selections = selections
    bootstrap.stringified = helpers.stringify bootstrap
    res.render 'store.ejs', { bootstrap: bootstrap }
  .catch (err) ->
    # TODO add better error pages
    console.error 'error in FEATURED', err
    res.send 'Not found'

# COLLECTIONS
app.get ['/shop/:collection'], (req, res, next) ->
  { bootstrap, host, path } = helpers.setup req
  collection = path.split('shop/')[1].replace(/[^\w]/gi, '_').toLowerCase()
  finders.userByHost host
  .then (data) ->
    helpers.assignBootstrap bootstrap, data[0]
    finders.selectionsByCollection data[0].id, collection
  .then (selections) ->
    # TODO add pagination
    bootstrap.collection  = helpers.humanize collection
    bootstrap.title       = helpers.formCollectionPageTitle bootstrap.collection, bootstrap.title
    bootstrap.selections  = selections || []
    bootstrap.images      = _.pluck selections.slice(0,5), 'image'
    bootstrap.stringified = helpers.stringify bootstrap
    res.render 'store.ejs', { bootstrap: bootstrap }
  .catch (err) ->
    console.error 'error in COLLECTIONS', err
    res.send 'Not found'

# SELECTIONS
app.get '/selections/:id/:slug', (req, res, next) ->
  { bootstrap, host, path } = helpers.setup req
  finders.userByHost host
  .then (data) ->
    helpers.assignBootstrap bootstrap, data[0]
    finders.selectionByIds req.params.id, data[0].id
  .then (selection) ->
    bootstrap.title = selection[0].title
    bootstrap.description = selection[0].content
    bootstrap.selection = selection[0]
    bootstrap.stringified = helpers.stringify bootstrap
    res.render 'store.ejs', { bootstrap: bootstrap }
  .catch (err) ->
    console.error 'error in SELECTIONS', err
    res.send 'Not found'

app.get '/cart', (req, res, next) ->
  { bootstrap, host, path } = helpers.setup req
  finders.userByHost host
  .then (data) ->
    helpers.assignBootstrap bootstrap, data[0]
    if req.cart and req.cart.quantity_array and req.cart.quantity_array.length > 0
      selection_ids = _.pluck req.cart.quantity_array, 'id'
      finders.selectionsByIds selection_ids.join(','), data[0].id
      .then (data) -> bootstrap.cart.selections = data
      .finally () ->
        bootstrap.stringified = helpers.stringify bootstrap
        res.render 'store.ejs', { bootstrap: bootstrap }
    else
      bootstrap.stringified = helpers.stringify bootstrap
      res.render 'store.ejs', { bootstrap: bootstrap }

app.listen process.env.PORT, ->
  console.log 'Store app listening on port ' + process.env.PORT
  return

switch process.env.NODE_ENV
  when 'production'
    require 'newrelic'
  when 'test'
    process.env.PORT = 4444
  else
    process.env.NODE_ENV = 'development'
    process.env.PORT = 4000

express     = require 'express'
morgan      = require 'morgan'
path        = require 'path'
serveStatic = require 'serve-static'
ejs         = require 'ejs'
Promise     = require 'bluebird'
_           = require 'lodash'
sequelize   = require './config/sequelize/setup'

app = express()
app.set 'view engine', 'ejs'
app.set 'views', path.join __dirname, 'dist'

if process.env.NODE_ENV is 'production' then app.use morgan 'common' else app.use morgan 'dev'

app.use serveStatic(path.join __dirname, 'dist')

storeByUsername = (username) -> sequelize.query 'SELECT id, storefront_meta, collections FROM "Users" WHERE username = ?', { type: sequelize.QueryTypes.SELECT, replacements: [username] }
storeByDomain   = (host) -> sequelize.query 'SELECT id, storefront_meta, collections FROM "Users" WHERE domain = ?', { type: sequelize.QueryTypes.SELECT, replacements: [host] }

selectionsByFeatured    = (seller_id) -> sequelize.query 'SELECT id, title, selling_price, image, collection from "Selections" WHERE seller_id = ? and featured = true', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id] }
selectionsByCollection  = (seller_id, collection) -> sequelize.query 'SELECT id, title, selling_price, image, collection from "Selections" WHERE seller_id = ? and collection = ?', { type: sequelize.QueryTypes.SELECT, replacements: [seller_id, collection] }

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

findByHostAndPath = (host, path) ->
  scope = {}
  findUserByHost host
  .then (res) ->
    scope = res[0]
    collection = null
    if path is '/'
      querySel = selectionsByFeatured
    else if path.indexOf('shop/') > -1
      collection = path.split('shop/')[1]
      querySel = if collection is 'featured' then selectionsByFeatured else selectionsByCollection
    else
      querySel = () -> return
    querySel scope.id, collection
  .then (res) ->
    scope.selections = res
    scope

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

app.get '/*', (req, res, next) ->
  bootstrap = {}
  host = req.headers.host
  path = req.url
  if path is '/favicon.ico' then return res.send 'favicon.ico not found'
  findByHostAndPath host, path
  .then (data) ->
    { storefront_meta, collections, selections, count } =  data
    if !storefront_meta then throw 'Not found'
    bootstrap =
      storefront_meta:  storefront_meta
      collections:      collections
      collection_names: collectionNames collections
      selections:       selections
      count:            count
    bootstrap.stringified = JSON.stringify(bootstrap).escapeSpecialChars()
    res.render 'store.ejs', { bootstrap: bootstrap }
  .catch (err) ->
    console.error 'error running query', err
    res.send 'Not found'

# TODO add proper routes http://expressjs.com/guide/routing.html
# app.get '/'
# app.get '/about'
# app.get '/collections/*'
# app.get '/shop/*'
# app.get '/cart'

app.listen process.env.PORT, ->
  console.log 'Store app listening on port ' + process.env.PORT
  return

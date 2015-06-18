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
sequelize   = require './config/sequelize/setup'
# bodyParser  = require 'body-parser'

app = express()
app.set 'view engine', 'ejs'
app.set 'views', path.join __dirname, 'dist'

if process.env.NODE_ENV is 'production' then app.use morgan 'common' else app.use morgan 'dev'

# app.use bodyParser.urlencoded({ extended: true })
# app.use bodyParser.json()

app.use serveStatic(path.join __dirname, 'dist')

findUserByHost = (host) ->
  host = host.replace 'www.', ''
  if process.env.NODE_ENV isnt 'production' or host.indexOf('eeosk.com') > -1 or host.indexOf('herokuapp.com') > -1
    username = 'demoseller'
    if host.indexOf('eeosk.com') > -1 then username = host.split('.')[0]
    sequelize.query 'SELECT id, storefront_meta, collections FROM "Users" WHERE username = ?', { type: sequelize.QueryTypes.SELECT, replacements: [username] }
  else
    sequelize.query 'SELECT id, storefront_meta, collections FROM "Users" WHERE domain = ?', { type: sequelize.QueryTypes.SELECT, replacements: [host] }

findSelectionsByPath = (path, bootstrap) ->
  selection_ids = []
  if !bootstrap.meta or !bootstrap.meta.collections then return new Promise.resolve([])
  if path is '/' or path.indexOf('/shop/') > -1
    collection = 'featured'
    if path.indexOf('/shop/') > -1 then collection = path.split('/shop/')[1].toLowerCase()
    selection_ids = bootstrap.meta.collections[collection]
    if selection_ids.length < 1 then return new Promise.resolve([])
    sequelize.query 'SELECT product_id, margin, selling_price, title, imgUrl, discontinued, out_of_stock, quantity, hidden FROM "Selections" WHERE id in ? AND seller_id = ?', { type: sequelize.QueryTypes.SELECT, replacements: [selection_ids, seller_id] }
  return new Promise.resolve([])

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
  # findByHostAndPath host, path
  findUserByHost host
  .then (data) ->
    user            = data[0]
    bootstrap.meta  = user.storefront_meta
    if !bootstrap.meta then throw 'Not found'
    findSelectionsByPath path, bootstrap
  .then (data) ->
    bootstrap.selections = {}
    bootstrap.stringified = JSON.stringify(bootstrap).escapeSpecialChars()
    res.render 'store.ejs', { bootstrap: bootstrap }
  .catch (err) ->
    console.error 'error running query', err
    res.send 'Not found'

app.listen process.env.PORT, ->
  console.log 'Store app listening on port ' + process.env.PORT
  return

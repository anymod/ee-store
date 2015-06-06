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
    sequelize.query 'SELECT storefront_meta FROM "Users" WHERE username = ?', { replacements: [username] }
  else
    sequelize.query 'SELECT storefront_meta FROM "Users" WHERE domain = ?', { replacements: [host] }

app.get '/*', (req, res, next) ->
  bootstrap = {}
  findUserByHost req.headers.host
  .then (data) ->
    bootstrap = data[0][0]
    res.render 'store.ejs', { bootstrap: bootstrap }
  .catch (err) ->
    console.error 'error running query', err
    res.send 'Not found'

app.listen process.env.PORT, ->
  console.log 'Store app listening on port ' + process.env.PORT
  return

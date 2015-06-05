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
app.set 'view engine', 'mustache'
app.set 'views', path.join __dirname, 'dist'

if process.env.NODE_ENV is 'production' then app.use morgan 'common' else app.use morgan 'dev'

# app.use bodyParser.urlencoded({ extended: true })
# app.use bodyParser.json()

app.use serveStatic(path.join __dirname, 'dist')

app.get '/*', (req, res, next) ->
  bootstrap = {}
  # client.query 'SELECT storefront_meta FROM "Users" WHERE username = $1', ['demoseller'], (err, data) ->
  sequelize.query 'SELECT storefront_meta FROM "Users" WHERE username = \'demoseller\''
  .then (data) ->
    bootstrap = data[0][0]
    # console.log bootstrap
    res.render 'store.ejs', { bootstrap: bootstrap }
  .catch (err) ->
    console.error 'error running query', err
    res.send 'Not found'


# app.all '/*', (req, res, next) ->
#   # Send store.html to support HTML5Mode
#   res.sendfile 'store.html', root: path.join __dirname, 'dist'
#   return

app.listen process.env.PORT, ->
  console.log 'Frontend listening on port ' + process.env.PORT
  return

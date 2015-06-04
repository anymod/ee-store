switch process.env.NODE_ENV
  when 'production'
    require 'newrelic'
  when 'test'
    process.env.PORT = 4444
  else
    process.env.NODE_ENV = 'development'
    process.env.PORT = 4000

express         = require 'express'
vhost           = require 'vhost'
morgan          = require 'morgan'
path            = require 'path'
serveStatic     = require 'serve-static'
bodyParser      = require 'body-parser'

# Parent app
app             = express()
store           = express()

if process.env.NODE_ENV is 'production'
  app.use morgan 'common'
else
  app.use morgan 'dev'

app.use bodyParser.urlencoded({ extended: true })
app.use bodyParser.json()

store.use serveStatic(path.join __dirname, 'dist')
store.all '/*', (req, res, next) ->
  # Send store.html to support HTML5Mode
  res.sendfile 'store.html', root: path.join __dirname, 'dist'
  return

app.use vhost('*.eeosk.com', store)
app.use vhost('localhost', store)

# Matching for external domains
app.use vhost('*.*', store)
app.use vhost('*.*.*', store)
app.use vhost('*.*.*.*', store)
app.use vhost('*.*.*.*.*', store)
app.use vhost('*.*.*.*.*.*', store)

app.listen process.env.PORT, ->
  console.log 'Frontend listening on port ' + process.env.PORT
  return

_         = require 'lodash'
url       = require 'url'
constants = require './server.constants'
finders   = require './server.finders'

h = {}

h.setup = (req) ->
  {
    bootstrap:
      cart: req.cart
      url: req.protocol + '://' + req.get('host') + req.originalUrl
      page: req.query.page
      perPage: constants.perPage
    host: req.headers.host
    path: url.parse(req.url).pathname
  }

h.humanize = (text) ->
  frags = text.split /_|-/
  (frags[i] = frags[i].charAt(0).toUpperCase() + frags[i].slice(1)) for i in [0..(frags.length - 1)]
  frags.join(' ')

h.assignCollectionTypes = (bootstrap, collections) ->
  bootstrap.collections = collections
  bootstrap.nav = {}
  bootstrap.nav.carousel = []
  bootstrap.nav.alphabetical = []
  setCollection = (coll) ->
    return unless coll.title
    if bootstrap.nav?.carousel?.length < 10 and coll.in_carousel and coll.banner.indexOf('placehold.it') is -1 then bootstrap.nav.carousel.push coll
  setCollection collection for collection in bootstrap.collections

module.exports = h

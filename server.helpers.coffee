_         = require 'lodash'
url       = require 'url'
constants = require './server.constants'

h = {}

h.setup = (req) ->
  {
    bootstrap:
      cart: req.cart
      url: req.protocol + '://' + req.get('host') + req.originalUrl
      pagination:
        page: req.query.page
        perPage: constants.perPage
    host: req.headers.host
    path: url.parse(req.url).pathname
  }

h.collectionNames = (collections) ->
  collections ||= {}
  names = ['featured']
  names.push name for name in Object.keys(collections)
  _.uniq names

h.assignBootstrap = (bootstrap, attrs) ->
  bootstrap.id                = attrs.id
  bootstrap.username          = attrs.username
  bootstrap.storefront_meta   = attrs.storefront_meta
  bootstrap.collections       = attrs.collections
  bootstrap.collection_names  = h.collectionNames attrs.collections
  bootstrap.title             = attrs.storefront_meta?.home?.name
  bootstrap.site_name         = attrs.storefront_meta?.home?.name
  bootstrap.images            = if attrs.storefront_meta?.home?.carousel[0]?.imgUrl then h.makeMetaImages([ attrs.storefront_meta?.home?.carousel[0]?.imgUrl ]) else []
  bootstrap

h.stringify = (obj) ->
  JSON.stringify(obj)
    .replace /&#34;/g,'"'
    .replace /\\n/g, "\\n"
    .replace /\\'/g, "\\'"
    .replace /\\"/g, '\\"'
    .replace /\\&/g, "\\&"
    .replace /\\r/g, "\\r"
    .replace /\\t/g, "\\t"
    .replace /\\b/g, "\\b"
    .replace /\\f/g, "\\f"

h.humanize = (text) ->
  frags = text.split /_|-/
  (frags[i] = frags[i].charAt(0).toUpperCase() + frags[i].slice(1)) for i in [0..(frags.length - 1)]
  frags.join(' ')

h.formCollectionPageTitle = (collection, title) ->
  if collection and title then (collection + ' | ' + title) else collection

h.makeMetaImage = (url) ->
  if !!url and url.indexOf("image/upload") > -1
    url.split("image/upload").join('image/upload/c_pad,w_600,h_314').replace('https://', 'http://')
  else
    url

h.makeMetaImages = (img_array) ->
  imgs = []
  imgs.push h.makeMetaImage(img) for img in img_array
  imgs

module.exports = h

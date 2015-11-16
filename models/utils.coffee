Promise   = require 'bluebird'
_         = require 'lodash'
url       = require 'url'
sequelize = require '../config/sequelize/setup'
constants = require '../server.constants'

utils =

  setup: (req) ->
    {
      bootstrap:
        cart: req.cart
        url: req.protocol + '://' + req.get('host') + req.originalUrl
        page: req.query.page
        perPage: constants.perPage
      host: req.headers.host
      path: url.parse(req.url).pathname
    }

  assignBootstrap: (bootstrap, attrs) ->
    bootstrap.id                = attrs.id
    bootstrap.username          = attrs.username
    bootstrap.storefront_meta   = attrs.storefront_meta or {}
    bootstrap.collections       = attrs.collections
    bootstrap.collection_names  = utils.collectionNames attrs.collections
    bootstrap.title             = attrs.storefront_meta?.home?.name
    bootstrap.site_name         = attrs.storefront_meta?.home?.name
    bootstrap.images            = if attrs.storefront_meta?.home?.carousel[0]?.imgUrl then utils.makeMetaImages([ attrs.storefront_meta?.home?.carousel[0]?.imgUrl ]) else []
    bootstrap.tracking          = if attrs.storefront_meta?.tracking?.ga_id then attrs.storefront_meta?.tracking?.ga_id else 'UA-55625421-5'
    bootstrap.h1                = attrs.storefront_meta?.seo?.h1 or bootstrap.title
    bootstrap.description       = attrs.storefront_meta?.seo?.description
    bootstrap.code              = if attrs.storefront_meta?.seo?.code then attrs.storefront_meta.seo.code.replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '<meta name="blocked" content="Scripts not allowed"/>').replace(/<iframe\b[^<]*(?:(?!<\/iframe>)<[^<]*)*<\/iframe>/gi, '<meta name="blocked" content="Frames not allowed"/>').replace(/src=/gi, 'src not allowed') else ''
    # Eliminate meta code to avoid stringify errors
    bootstrap.storefront_meta.seo = {}
    bootstrap

  stringify: (obj) ->
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

  makeMetaImage: (url) ->
    if url and url.indexOf("image/upload") > -1 then url.split("image/upload").join('image/upload/c_pad,w_600,h_314').replace('https://', 'http://') else url

  makeMetaImages: (img_array) ->
    imgs = []
    imgs.push utils.makeMetaImage(img) for img in img_array
    imgs

  collectionNames: (collections) ->
    collections ||= {}
    names = ['featured']
    names.push name for name in Object.keys(collections)
    _.uniq names

  formCollectionPageTitle: (collection, title) ->
    if collection and title then (collection + ' | ' + title) else collection

# LEFTOVERS FROM HELPERS
# humanize: (text) ->
#   frags = text.split /_|-/
#   (frags[i] = frags[i].charAt(0).toUpperCase() + frags[i].slice(1)) for i in [0..(frags.length - 1)]
#   frags.join(' ')
# assignCollectionTypes: (bootstrap, collections) ->
#   bootstrap.collections = collections
#   bootstrap.nav = {}
#   bootstrap.nav.carousel = []
#   bootstrap.nav.alphabetical = []
#   setCollection = (coll) ->
#     return unless coll.title
#     if bootstrap.nav?.carousel?.length < 10 and coll.in_carousel and coll.banner.indexOf('placehold.it') is -1 then bootstrap.nav.carousel.push coll
#   setCollection collection for collection in bootstrap.collections

module.exports = utils

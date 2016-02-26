Promise   = require 'bluebird'
_         = require 'lodash'
url       = require 'url'
sequelize = require '../config/sequelize/setup'
constants = require '../server.constants'

utils =

  setup: (req) ->
    {
      bootstrap:
        cart:     req.cart
        url:      req.protocol + '://' + req.get('host') + req.originalUrl
        perPage:  constants.perPage
        query:    req.query.q
        page:     req.query.p
        order:    req.query.s
        range:    req.query.r
        referer:  req.headers.referer
      host: req.headers.host
      path: url.parse(req.url).pathname
      protocol: req.headers.protocol
    }

  assignBootstrap: (bootstrap, attrs) ->
    bootstrap.id                = attrs.id
    bootstrap.username          = attrs.username
    bootstrap.tr_uuid           = attrs.tr_uuid
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

  rangeToPrices: (range) ->
    return [null, null] unless range
    [min, max] = range.split('-')
    [parseInt(min)*100, parseInt(max)*100]

  yyyymmdd: () ->
    date = new Date()
    yyyy = '' + date.getFullYear()
    mm = '' + (date.getMonth() + 1)
    dd = '' + date.getDate()
    if !mm[1] then mm = '0' + mm
    if !dd[1] then dd = '0' + dd
    [yyyy,mm,dd].join('-')

module.exports = utils

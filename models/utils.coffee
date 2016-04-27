Promise   = require 'bluebird'
_         = require 'lodash'
url       = require 'url'
sequelize = require '../config/sequelize/setup'
constants = require '../server.constants'

Shared    = require '../copied-from-ee-back/shared'

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
      protocol: req.protocol
    }

  assignBootstrap: (bootstrap, attrs) ->
    bootstrap[attr] = attrs[attr] for attr in ['id', 'username', 'tr_uuid', 'logo', 'categorization_ids', 'pricing']
    bootstrap.storefront_meta   = attrs.storefront_meta or {}
    bootstrap.home_carousel     = attrs.home_carousel or []
    bootstrap.home_arranged     = attrs.home_arranged or []
    bootstrap.title             = attrs.storefront_meta?.name
    bootstrap.site_name         = attrs.storefront_meta?.name
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

  orderedResults: Shared.Utils.orderedResults

  makeMetaImage: (url) ->
    if url and url.indexOf("image/upload") > -1 then url.split("image/upload").join('image/upload/c_pad,w_600,h_314').replace('https://', 'http://') else url

  makeMetaImages: (img_array) ->
    imgs = []
    imgs.push utils.makeMetaImage(img) for img in img_array
    imgs

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

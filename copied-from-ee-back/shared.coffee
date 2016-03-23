sequelize     = require '../config/sequelize/setup'
elasticsearch = require '../config/elasticsearch/setup'
Promise       = require 'bluebird'
_             = require 'lodash'

data =
  User: {}
  Product: {}
  Collection: {}
  Customization: {}

fns =
  User: {}
  Product: {}
  Collection: {}
  Customization: {}

### USER ###
### /USER ###

### PRODUCT ###
fns.Product.search = (user, opts) ->
  scope   = {}
  user  ||= {}
  opts  ||= {}

  # Initial body
  body =
    size: opts.size
    filter:
      and: [
        { bool: must_not: term: hide_from_catalog: true },
        { bool: must: has_child: {
          type: 'sku',
          filter:
            and: [
              { bool: must: range: regular_price: { gte: opts.min_price, lte: opts.max_price } }
              # { bool: must: range: supplier_id: { gte: 3797, lte: 3797 } }
            ]
        } }
      ]

  # Pagination
  if opts.size and opts.page then body.from = parseInt(opts.size) * (parseInt(opts.page) - 1)

  # Search
  if opts.search
    body.query =
      fuzzy_like_this:
        fields: ['title', 'content']
        like_text: opts.search
        fuzziness: 1
      # multi_match:
      #   type: 'most_fields'
      #   query: opts.search
      #   fields: ['title', 'content']
    # body.highlight =
    #   pre_tags: ['<strong>']
    #   post_tags: ['</strong>']
    #   fields:
    #     title:
    #       force_source: true
    #       fragment_size: 150
    #       number_of_fragments: 1

  # Sort
  if opts.order is 'updated_at DESC'
    body.sort = [{ updated_at: { order: 'DESC' }} ]

  # Categorization
  ids = if opts.category_ids then ('' + opts.category_ids).split(',') else user.categorization_ids
  if ids
    body.filter.and.push({
      bool:
        must:
          terms:
            category_id: ids
    })

  # Supplier
  if user?.admin? and opts.supplier_id
    body.filter.and[1].bool.must.has_child.filter.and.push({
      bool:
        must:
          term:
            supplier_id: parseInt(opts.supplier_id)
    })

  # console.log 'body', body.filter.and

  elasticsearch.client.search
    index: 'products_search'
    _source: data.Product.elasticsearch_findall_attrs
    body: body
  .then (res) ->
    scope.rows    = _.map res?.hits?.hits, '_source'
    scope.count   = res?.hits?.total
    scope.took    = res.took
    scope.page    = opts?.page
    scope.perPage = opts?.size
    fns.Product.addAdminDetailsFor user, scope.rows
  .then () -> fns.Product.addCustomizationsFor user, scope.rows
  .then () ->
    scope
  .catch (err) ->
    console.log 'err', err
    throw err

fns.Product.sort = (user, opts) ->
  scope         = {}
  user        ||= {}
  opts        ||= {}
  replacements  = []

  # Product IDs
  product_ids_filter = ' '
  if opts.product_ids then product_ids_filter = ' AND p.id IN (' + opts.product_ids.split(',').join(',') + ') '

  # Categorization
  category_ids = null
  if opts.categorized
    category_ids = if opts.category_ids then ('' + opts.category_ids).split(',') else user.categorization_ids
  if !category_ids then category_ids = [1,2,3,4,5,6]

  # Price
  price_filter = ' '
  if opts.min_price then price_filter += ' AND s.regular_price > ' + parseInt(opts.min_price) + ' '
  if opts.max_price then price_filter += ' AND s.regular_price < ' + parseInt(opts.max_price) + ' '

  # Supplier
  supplier_filter = ' '
  if user?.admin? and opts.supplier_id
    supplier_filter = ' AND s.supplier_id = ? '
    replacements.push opts.supplier_id

  # Featured
  # opts.feat = true
  featured_join = ' '
  if opts.feat then featured_join = ' JOIN "Customizations" c ON c.product_id = p.id AND c.seller_id = ' + user.id + ' AND c.featured = true '

  # Order
  order = 'p.updated_at DESC'
  if opts.order is 'pa' then order = 'min_price ASC'
  if opts.order is 'pd' then order = 'max_price DESC'
  if opts.order is 'ta' then order = "LOWER(regexp_replace(p.title, '[^[:alpha:]]', '', 'g')) ASC"
  if opts.order is 'td' then order = "LOWER(regexp_replace(p.title, '[^[:alpha:]]', '', 'g')) DESC"

  # Limit
  limit = if opts.size then parseInt(opts.size) else 48

  # Offset
  offset = if opts.page then ((parseInt(opts.page) - 1) * limit) else 0

  scope.page    = parseInt(offset / limit) + 1
  scope.perPage = limit

  baseQuery =
    ' FROM "Products" p
      ' + featured_join + '
      JOIN "Skus" s
      ON p.id = s.product_id
      WHERE p.category_id in (' + category_ids.join(',') + ') AND p.hide_from_catalog IS NOT true
      ' + product_ids_filter + '
      ' + supplier_filter + '
      ' + price_filter + '
      GROUP BY p.id '

  q =
    'SELECT p.id, p.title, p.image, p.category_id, p.discontinued, array_agg(s.regular_price) as regular_prices, array_agg(s.msrp) as msrps, min(s.regular_price) AS min_price, max(s.regular_price) AS max_price' +
    baseQuery + 'ORDER BY ' + order + ' LIMIT ' + limit + ' OFFSET ' + offset + ';'

  countQuery = 'SELECT count(*) FROM (SELECT p.id' + baseQuery + ') AS countable;'

  sequelize.query q, { type: sequelize.QueryTypes.SELECT, replacements: replacements }
  .then (res) ->
    scope.rows = res
    sequelize.query countQuery, { type: sequelize.QueryTypes.SELECT, replacements: replacements }
  .then (res) ->
    scope.count = if res[0]?.count then parseInt(res[0].count) else null
    fns.Product.addAdminDetailsFor user, scope.rows
  .then () -> fns.Product.addCustomizationsFor user, scope.rows
  .then () ->
    scope

fns.Product.findById = (id) ->
  q =
  'SELECT p.id, p.title, p.image, p.content, p.additional_images, p.category_id, p.discontinued, array_agg(s.regular_price) as regular_prices, array_agg(s.msrp) as msrps
    FROM "Products" p
    JOIN "Skus" s
    ON p.id = s.product_id
    WHERE p.id = ?
    GROUP BY p.id'
  sequelize.query q, { type: sequelize.QueryTypes.SELECT, replacements: [id] }
  .then (products) -> products[0]

fns.Product.findAllByIds = (ids, opts) ->
  opts ||= {}
  limit  = if opts?.limit  then (' LIMIT '  + parseInt(opts.limit) + ' ') else ' '
  offset = if opts?.offset then (' OFFSET ' + parseInt(opts.offset) + ' ') else ' '
  q =
  'SELECT p.id, p.title, p.image, p.category_id, p.discontinued, array_agg(s.regular_price) as regular_prices, array_agg(s.msrp) as msrps
    FROM "Products" p
    JOIN "Skus" s
    ON p.id = s.product_id
    WHERE p.id IN (' + ids + ')
    GROUP BY p.id
    ORDER BY p.updated_at DESC' + limit + ' ' + offset + ';'
  sequelize.query q, { type: sequelize.QueryTypes.SELECT }

fns.Product.addCustomizationsFor = (user, products) ->
  if !products or products.length < 1 then return
  product_ids = _.map products, 'id'
  for product in products
    product.featured  = false
    product.prices    = product.regular_prices
    if product.skus
      product.msrps   = _.map product.skus, 'msrp'
      product.prices  = _.map product.skus, 'regular_price'
      sku.price = sku.regular_price for sku in product.skus
  q = 'SELECT product_id, title, featured, selling_prices FROM "Customizations" WHERE seller_id = ? AND product_id IN (' + product_ids.join(',') + ');'
  sequelize.query q, { type: sequelize.QueryTypes.SELECT, replacements: [user.id] }
  .then (customizations) ->
    for product in products
      for customization in customizations
        if customization.product_id is product.id
          if product.skus then fns.Customization.alterSkus product.skus, customization
          if !product.skus and customization.selling_prices and customization.selling_prices.length > 0 then product.prices = _.map customization.selling_prices, 'selling_price'
          fns.Customization.alterProduct product, customization
      if !product.skus then product.skus = null
    # TODO return prices and msrps in order
    products

fns.Product.addAdminDetailsFor = (user, products) ->
  if user.admin isnt true or !products or products.length < 1 then return
  product_ids = _.map products, 'id'
  q = 'SELECT * FROM "Products" WHERE id IN (' + product_ids.join(',') + ');'
  sequelize.query q, { type: sequelize.QueryTypes.SELECT, replacements: [user.id] }
  # Product.findAll where: { id: $in: product_ids }
  .then (prods) ->
    for prod in prods
      for product in products
        if prod.id is product.id then product.external_identity = prod.external_identity

data.Product.elasticsearch_findall_attrs = [
  'id'
  'title'
  'discontinued'
  'image'
  'category_id'
  'skus'
  # 'msrps'
  # 'regular_prices'
]
### /PRODUCT ###

### COLLECTION ###
fns.Collection.formattedResponse = (collection, user, opts) ->
  scope         = {}
  collection  ||= {}
  user        ||= {}
  opts        ||= {}
  opts.product_ids = if collection.product_ids?.length > 0 then collection.product_ids.join(',') else '0'
  fns.Product.sort user, opts
  .then (res) ->
    res.collection = _.omit collection, data.Collection.restricted_attrs
    res

data.Collection.restricted_attrs = ['title', 'headline', 'button', 'cloned_from', 'creator_id', 'seller_id', 'deleted_at', 'featured', 'template_ids']

### /COLLECTION ###

### CUSTOMIZATION ###
fns.Customization.alterSkus = (skus, customization) ->
  skus ||= []
  customization ||= {}
  for sku in skus
    if customization?.selling_prices
      res = _.filter customization.selling_prices, { sku_id: sku.id }
      sku.price = if res and res.length > 0 then res[0].selling_price else sku.regular_price
    else
      sku.price = sku.regular_price
  customization

fns.Customization.alterProduct = (product, customization) ->
  product ||= {}
  customization ||= {}
  if customization?.title then product.title = customization.title
  product.featured = !!customization?.featured
  if product.skus
    product.msrps = _.map product.skus, 'msrp'
    product.prices = _.map product.skus, 'price'
  customization

### /CUSTOMIZATION ###

module.exports = fns

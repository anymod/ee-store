process.env.NODE_ENV = 'test'
sequelize = require './utils.e2e.sequelize'
Promise   = require 'bluebird'
request   = require 'request'
jwt       = require 'jsonwebtoken'
_         = require 'lodash'

utils = {}
scope = {}

random_string       = () -> Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0,5)
random_string_const = Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0,5)

utils.test_admin =
  username:       'test-admin'
  email:          'test-admin@foo.bar'
  password:       'foobarbaz'
  password_hash:  '$2a$05$YB1MyntOM2MHwODctZBy7O.GmpfrLm6xlZZxB30IpR3Ushi7auCaC'

utils.test_user =
  username:       'test-user'
  email:          'test-user@foo.bar'
  password:       'foobarbaz'
  password_hash:  '$2a$05$YB1MyntOM2MHwODctZBy7O.GmpfrLm6xlZZxB30IpR3Ushi7auCaC'
  storefront_meta:
    home:
      name: 'Test User Store'
      topBarColor: '#000444'
      topBarBackgroundColor: '#FFCC42'

utils.random_user =
  username:       random_string_const
  email:          random_string_const + '@foo.bar'
  password:       'foobarbaz'
  password_hash:  '$2a$05$YB1MyntOM2MHwODctZBy7O.GmpfrLm6xlZZxB30IpR3Ushi7auCaC'

if process.env.NODE_ENV is 'test'

  utils.jwt = (obj) -> jwt.sign(obj, 'foobar', { expiresInMinutes: 10800 })

  utils.delete_all_tables = () ->
    utils.delete_all_users()
    .then () -> utils.delete_all_products()
    .then () -> utils.delete_all_selections()
    .then () -> utils.delete_all_orders()

  utils.delete_all_users = () ->
    new Promise (resolve, reject) ->
      sequelize.query 'delete from "Users"', null, { raw: true }
        .success (data) -> resolve data
        .error (err) -> reject err

  utils.delete_all_products = () ->
    new Promise (resolve, reject) ->
      sequelize.query 'delete from "Products"', null, { raw: true }
        .success (data) -> resolve data
        .error (err) -> reject err

  utils.delete_all_selections = () ->
    new Promise (resolve, reject) ->
      sequelize.query 'delete from "Selections"', null, { raw: true }
        .success (data) -> resolve data
        .error (err) -> reject err

  utils.delete_all_orders = () ->
    new Promise (resolve, reject) ->
      sequelize.query 'delete from "Orders"', null, { raw: true }
        .success (data) -> resolve data
        .error (err) -> reject err

  utils.create_user = (user) ->
    req = request.defaults
      json: true
      uri: browser.apiUrl + '/v0/users'
      body: email: user.email
      headers: authorization: {}
    new Promise (resolve, reject) ->
      req.post {}, (err, res, body) ->
        last_user_created = body
        if !!err then reject err else resolve body

  utils.users             = ()          -> sequelize.query 'SELECT * FROM "Users";'
  utils.user_by_id        = (id)        -> sequelize.query 'SELECT * FROM "Users" WHERE id = ' + id + ' LIMIT 1;'
  utils.user_by_email     = (email)     -> sequelize.query 'SELECT * FROM "Users" WHERE email = \'' + email + '\' LIMIT 1;'
  utils.user_by_username  = (username)  -> sequelize.query 'SELECT * FROM "Users" WHERE username = \'' + username + '\' LIMIT 1;'
  utils.confirm_user      = (email)     -> sequelize.query 'UPDATE "Users" SET confirmed = true, confirmed_at = created_at WHERE email = \'' + email + '\';'
  utils.complete_user     = (email)     -> sequelize.query 'UPDATE "Users" SET confirmed = true, confirmed_at = created_at, completed = true, completed_at = created_at WHERE email = \'' + email + '\';'
  utils.jwt_from_email    = (email) ->
    sequelize.query 'SELECT ee_uuid FROM "Users" WHERE email = \'' + email + '\';'
    .then (res) ->
      ee_uuid = res[0].ee_uuid
      'Bearer ' + utils.jwt({ token: ee_uuid })
    .catch (err) -> throw 'error in user_token_from_email'

  utils.create_admin = () ->
    utils.create_user utils.test_admin
    .then (body) ->
      scope.admin_user = body
      utils.complete_user body.email
      sequelize.query 'UPDATE "Users" SET "admin"=true WHERE "email"= \'' + body.email + '\';'
      utils.jwt_from_email body.email
    .then (token) ->
      scope.admin_token = token
      scope.admin_user
    .catch (err) -> throw err

  utils.create_products = (n, category) ->
    createOps = []
    createOp = (i) -> createOps.push(utils.create_product(i, category))
    if typeof n is 'number' then _.times n, (i) -> createOp(i+1)
    if n instanceof Array then createOp(i) for i in n

    Promise.all(createOps)

  utils.create_product = (i, cat) ->
    supply_price = parseInt(Math.random()*100)*100 + 800
    ee_margin = 10
    random_color = () -> Math.random().toString(16).slice(2, 8)
    w = '800'
    h = '600'
    if Math.random()*2 > 1 then [w,h] = [h,w]
    main_image = 'http://placehold.it/' + w + 'x' + h + '.png/' + random_color() + '/fff'
    image_2 = 'http://placehold.it/' + h + 'x' + h + '.png/' + random_color() + '/fff'
    image_3 = 'http://placehold.it/' + h + 'x' + w + '.png/' + random_color() + '/fff'
    image_4 = 'http://placehold.it/' + w + 'x' + w + '.png/' + random_color() + '/fff'
    categories = ["Kitchen", "Furniture", "Home Accents", "Outdoor"]
    category = cat || _.sample categories
    search_term = _.sample(['Handmade', 'Green', 'Metal']) + ' ' + category
    req = request.defaults
      json: true
      uri: browser.apiUrl + '/v0/products'
      body:
        supplier_id: parseInt(Math.random()*1000)
        supply_price: supply_price
        baseline_price: parseInt(supply_price * (100 + ee_margin)/100)
        suggested_price: parseInt(supply_price * (100 + 30)/100)
        title: '' + search_term + ' product (' + i + ')'
        content: 'Content for Product ' + i + '. Product is in the category ' + category + '. It\'s ' + search_term + '.'
        content_meta: {}
        image_meta:
          main_image:
            url: main_image
          additional_images: [
            { url: image_2 },
            { url: image_3 },
            { url: image_4 },
          ]
        availability_meta: {}
        category: category
      headers: authorization: scope.admin_token
    new Promise (resolve, reject) ->
      req.post {}, (err, res, body) ->
        if !!err then reject err else resolve body

  utils.product_by_id = (id) -> sequelize.query 'SELECT * FROM "Products" WHERE id = ' + id + ' LIMIT 1;'


  utils.create_selections = (product_ids, token) ->
      createOps = []
      createOps.push(utils.create_selection(product_id, token)) for product_id in product_ids
      Promise.all(createOps)

  utils.create_selection = (product_id, token) ->
    req = request.defaults
      json: true
      uri: browser.apiUrl + '/v0/selections'
      body:
        supplier_id: parseInt(Math.random()*1000)
        product_id: product_id
        margin: 15
        storefront_meta: {}
        catalog_meta: {}
        orders_meta: {}
      headers: authorization: token
    new Promise (resolve, reject) ->
      req.post {}, (err, res, body) ->
        if !!err then reject err else resolve body

  utils.log_in = (token) ->
    browser.get '/'
    token = token.replace 'Bearer ', 'Bearer%20'
    browser.manage().addCookie('loginToken', token)
    browser.get '/'

  utils.log_out = () ->
    browser.manage().deleteAllCookies()

  utils.reset = (brws) ->
    scope = {}
    brws.get '/logout'
    brws.sleep(100)
    utils.delete_all_tables()
    .then () -> utils.create_admin()
    .then () -> utils.create_user(utils.test_user)
    .then (data) ->
      scope.user = data
      utils.complete_user data.email
      utils.jwt_from_email data.email
    .then (token) ->
      scope.token = token
      utils.create_products(10)
    .then (products) ->
      scope.products = products
      utils.create_selections(_.pluck(products, 'id'), scope.token)
    .then (selections) ->
      scope.selections = selections
      utils.create_products([11..20])
    .then (products) ->
      scope.products = scope.products.concat products
      scope

  utils.reset_and_login = (brws) ->
    utils.reset(brws)
    .then () ->
      utils.log_in scope.token
      scope

  utils.hex_to_rgb = (hex) ->
    result = (/^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i).exec(hex)
    'color: rgb(' + parseInt(result[1], 16) + ', ' + parseInt(result[2], 16) + ', ' + parseInt(result[3], 16) + ')'

module.exports = utils

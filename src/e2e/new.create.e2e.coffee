process.env.NODE_ENV = 'test'
utils           = require './utils.e2e.db'
chai            = require 'chai'
expect          = require('chai').expect
should          = chai.should()
chaiAsPromised  = require 'chai-as-promised'
chai.use chaiAsPromised
_               = require 'lodash'

elem    = {}
scope   = {}

describe 'eeosk new.create', () ->

  before () ->
    utils.reset browser
    .then (res) ->
      scope = res
      scope.categories = ['All'].concat _.unique(_.pluck scope.products, 'category')
    .then () -> utils.create_user { email: 'new-user@foo.bar' }
    .then (body) -> utils.user_by_email body.email
    .then (user) ->
      scope.user = user[0]
      utils.create_products([21..97], 'Home Accents')

  describe 'going through the flow', () ->

    it 'should have proper messaging', () ->
      browser.get '/create/' + scope.user.confirmation_token
      browser.getTitle().should.eventually.contain 'Create your store'

    it 'should start on "Choose products"', () ->
      element(has.css '#messages').getText()
      .then (text) ->
        text.should.contain 'Choose a few products to get your store started'
        text.should.not.contain 'Choose a starting theme'
        text.should.not.contain 'Create login'

    describe 'navigating via numbered segments', () ->

      it 'should navigate to Choose theme', () ->
        element(has.cssContainingText '.well .hover-pointer', '2. Choose theme').click()
        element(has.css '#messages').getText()
        .then (text) ->
          text.should.not.contain 'Choose a few products to get your store started'
          text.should.contain 'Choose a starting theme'
          text.should.not.contain 'Create login'

      it 'should navigate to Finishing touches', () ->
        element(has.cssContainingText '.well .hover-pointer', '3. Finishing touches').click()
        element(has.css '#messages').getText()
        .then (text) ->
          text.should.not.contain 'Choose a few products to get your store started'
          text.should.not.contain 'Choose a starting theme'
          text.should.contain 'Create login'

      it 'should navigate to Choose products', () ->
        element(has.cssContainingText '.well .hover-pointer', '1. Choose products').click()
        element(has.css '#messages').getText()
        .then (text) ->
          text.should.contain 'Choose a few products to get your store started'
          text.should.not.contain 'Choose a starting theme'
          text.should.not.contain 'Create login'

    describe 'navigating via next and back buttons', () ->

      it 'should go next from Choose products page', () ->
        element(has.css '#messages').getText()
        .then (text) ->
          text.should.contain 'Choose a few products to get your store started'
          text.should.not.contain 'Choose a starting theme'
          text.should.not.contain 'Create login'
          element(has.css 'i.fa-long-arrow-right').click()
          element(has.css '#messages').getText()
        .then (text) ->
          text.should.not.contain 'Choose a few products to get your store started'
          text.should.contain 'Choose a starting theme'
          text.should.not.contain 'Create login'

      it 'should go next from Choose theme page', () ->
        element(has.css 'i.fa-long-arrow-right').click()
        element(has.css '#messages').getText()
        .then (text) ->
          text.should.not.contain 'Choose a few products to get your store started'
          text.should.not.contain 'Choose a starting theme'
          text.should.contain 'Create login'

      it 'should go back from Finishing touches page', () ->
        element(has.css 'i.fa-long-arrow-left').click()
        element(has.css '#messages').getText()
        .then (text) ->
          text.should.not.contain 'Choose a few products to get your store started'
          text.should.contain 'Choose a starting theme'
          text.should.not.contain 'Create login'

      it 'should go back from Choose theme page', () ->
        element(has.css 'i.fa-long-arrow-left').click()
        element(has.css '#messages').getText()
        .then (text) ->
          text.should.contain 'Choose a few products to get your store started'
          text.should.not.contain 'Choose a starting theme'
          text.should.not.contain 'Create login'

    describe 'Choose products page', () ->

      # TODO change to 96 products and check that all are from Home Accents
      it 'should have 48 products from Home Accents', () ->
        element.all(has.repeater 'product in create.data.products')
        .then (elems) -> elems.length.should.equal 48

    describe 'Choose theme page', () ->

      it 'should have 20 themes', () ->
        element(has.css 'i.fa-long-arrow-right').click()
        element.all(has.repeater 'theme in create.landingData.demoStores')
        .then (elems) -> elems.length.should.equal 20

    describe 'Finishing touches page', () ->

      it 'should show validation for username length', () ->
        element(has.css 'i.fa-long-arrow-right').click()
        element(has.model 'create.username').sendKeys 'foo'
        element(has.model 'create.password').sendKeys 'foobarbaz'
        element(has.model 'create.password_confirm').sendKeys 'foobarbaz'
        element(has.css 'button[type="submit"]').click()
        element(has.css '#messages').getText().should.eventually.contain 'Username must be between 5 and 25 characters'

      it 'should show validation for password length', () ->
        element(has.model 'create.username').clear().sendKeys 'a-new-user'
        element(has.model 'create.password').clear().sendKeys 'foobar'
        element(has.model 'create.password_confirm').clear().sendKeys 'foobar'
        element(has.css 'button[type="submit"]').click()
        element(has.css '#messages').getText().should.eventually.contain 'Password must be at least 8 characters'

  describe 'Entire flow should persist 5 products, 1 theme, and signin info -', () ->

    it 'choose 5 products', () ->
      browser.get '/create/' + scope.user.confirmation_token
      # (TODO add promise library to make test less ugly)
      scope.product_ids = []
      elem = element(has.repeater('product in create.data.products').row(1))
      elem.element(has.cssContainingText '.btn-default', 'Add').click()
      elem.element(has.css 'p').getText()
      .then (text) ->
        scope.product_ids.push parseInt(text.split('(')[1].split(')')[0])
        elem = element(has.repeater('product in create.data.products').row(2))
        elem.element(has.cssContainingText '.btn-default', 'Add').click()
        elem.element(has.css 'p').getText()
      .then (text) ->
        scope.product_ids.push parseInt(text.split('(')[1].split(')')[0])
        elem = element(has.repeater('product in create.data.products').row(3))
        elem.element(has.cssContainingText '.btn-default', 'Add').click()
        elem.element(has.css 'p').getText()
      .then (text) ->
        scope.product_ids.push parseInt(text.split('(')[1].split(')')[0])
        elem = element(has.repeater('product in create.data.products').row(16))
        elem.element(has.cssContainingText '.btn-default', 'Add').click()
        elem.element(has.css 'p').getText()
      .then (text) ->
        scope.product_ids.push parseInt(text.split('(')[1].split(')')[0])
        elem = element(has.repeater('product in create.data.products').row(20))
        elem.element(has.cssContainingText '.btn-default', 'Add').click()
        elem.element(has.css 'p').getText()
      .then (text) ->
        scope.product_ids.push parseInt(text.split('(')[1].split(')')[0])
        scope.product_ids.length.should.equal 5

    it 'choose theme', () ->
      element(has.css 'i.fa-long-arrow-right').click()
      # browser.sleep 3000
      element(has.cssContainingText '.col', 'Desk 2').element(has.css '.btn').click()

    it 'enter login information and submit', () ->
      element(has.css 'i.fa-long-arrow-right').click()
      element(has.model 'create.username').clear().sendKeys 'create-flow-user'
      element(has.model 'create.password').clear().sendKeys 'foobarbaz'
      element(has.model 'create.password_confirm').clear().sendKeys 'foobarbaz'
      element(has.css 'button[type="submit"]').click()
      browser.getTitle().should.eventually.contain 'My store'

    it 'should have the right store loaded', () ->
      element(has.css '.carousel img').getAttribute('src').should.eventually.equal 'https://res.cloudinary.com/eeosk/image/upload/c_fill,h_400,w_1200/v1425250486/desk2.jpg'
      # TODO promise library to make this test less ugly
      element.all(has.repeater 'product in storefront.ee.product_selection')
      .then (elems) ->
        scope.elems = elems
        scope.elems.length.should.equal 5
        scope.elems[0].element(has.css '.product-title').getText()
      .then (text) ->
        id = parseInt(text.split('(')[1].split(')')[0])
        expect(scope.product_ids.indexOf(id)).to.be.above -1
        scope.elems[1].element(has.css '.product-title').getText()
      .then (text) ->
        id = parseInt(text.split('(')[1].split(')')[0])
        expect(scope.product_ids.indexOf(id)).to.be.above -1
        scope.elems[2].element(has.css '.product-title').getText()
      .then (text) ->
        id = parseInt(text.split('(')[1].split(')')[0])
        expect(scope.product_ids.indexOf(id)).to.be.above -1
        scope.elems[3].element(has.css '.product-title').getText()
      .then (text) ->
        id = parseInt(text.split('(')[1].split(')')[0])
        expect(scope.product_ids.indexOf(id)).to.be.above -1
        scope.elems[4].element(has.css '.product-title').getText()
      .then (text) ->
        id = parseInt(text.split('(')[1].split(')')[0])
        expect(scope.product_ids.indexOf(id)).to.be.above -1

    ## TODO implement further create tests
    xit 'should redirect to signin if user already completed', () ->
    xit 'should redirect to "Check your email" if token expired', () ->
    xit 'should redirect to "Token not found" if token not found', () ->

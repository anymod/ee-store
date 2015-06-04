process.env.NODE_ENV = 'test'
utils           = require './utils.e2e.db'
chai            = require 'chai'
expect          = require('chai').expect
should          = chai.should()
chaiAsPromised  = require 'chai-as-promised'
chai.use chaiAsPromised
_               = require 'lodash'

elem    = {}
newVal  = {}
scope   = {}

describe 'eeosk storefront.shop', () ->

  before (done) ->
    offscreen = element byAttr.css '#ee-offscreen'
    onscreen  = element byAttr.css '#ee-main'
    navbar    = element byAttr.css 'nav.navbar-rgba-colors'
    elem =
      loginBtn:               onscreen.element byAttr.cssContainingText('.btn', 'Login')

      homeBtn:                offscreen.element byAttr.cssContainingText('.btn', 'Home')
      shopBtn:                offscreen.element byAttr.cssContainingText('.btn', 'Shop')
      blogBtn:                offscreen.element byAttr.cssContainingText('.btn', 'Blog')
      aboutBtn:               offscreen.element byAttr.cssContainingText('.btn', 'About')
      socialBtn:              offscreen.element byAttr.cssContainingText('.btn', 'Social')

      save:                   element byAttr.name 'save'
      offscreenBtn:           offscreen.element byAttr.css  'button.dropdown-toggle'
      ofscDrop:               offscreen.element byAttr.css  '.btn-group > ul.dropdown-menu'

      navShopBtn:             navbar.element byAttr.css 'ul.nav.navbar-nav:nth-child(1) > li:nth-child(2)'

      navPills:               element byAttr.css '.col ul.nav-pills'

    utils.reset_and_login(browser)
    .then (res) ->
      scope = res
      scope.categories = ['All'].concat _.unique(_.pluck scope.products, 'category')

  it 'should have the proper title', () ->
    elem.loginBtn             .click()
    elem.shopBtn              .click()
    browser                   .getTitle().should.eventually.equal 'Build your store | eeosk'

  it 'should visit the shop section and have the right elements highlighted', () ->
    ## Check current category button
    elem.offscreenBtn         .getText().should.eventually.contain 'All'
    elem.ofscDrop             .element(byAttr.css('li:nth-child(1)')).getAttribute('class').should.eventually.contain 'active'
    # TODO fix race condition in the current category dropdown call
    # elem.ofscDrop.element(byAttr.css('li:nth-child(2)'))  .getAttribute('class').should.eventually.equal 'ng-scope'
    ## Check main section nav pills
    elem.navPills             .element(byAttr.css('li:nth-child(1)')).getAttribute('class').should.eventually.contain 'active'
    elem.navPills             .element(byAttr.css('li:nth-child(2)')).getAttribute('class').should.eventually.equal 'ng-scope'
    ## Check navbar dropdown
    elem.navShopBtn           .element(byAttr.css('li:nth-child(1)')).getAttribute('class').should.eventually.contain 'active'
    elem.navShopBtn           .element(byAttr.css('li:nth-child(2)')).getAttribute('class').should.eventually.equal 'ng-scope'

  it 'should visit another category and have the right elements highlighted', () ->
    browser.get '/storefront/shop/' + scope.categories[1]
    browser.getTitle().should.eventually.equal 'Build your store | eeosk'
    ## Check current category button
    elem.offscreenBtn                                     .getText().should.eventually.contain scope.categories[1]
    elem.ofscDrop.element(byAttr.css('li:nth-child(1)'))  .getAttribute('class').should.eventually.equal 'ng-scope'
    elem.ofscDrop.element(byAttr.css('li:nth-child(2)'))  .getAttribute('class').should.eventually.contain 'active'
    ## Check main section nav pills
    elem.navPills.element(byAttr.css('li:nth-child(1)'))  .getAttribute('class').should.eventually.equal 'ng-scope'
    elem.navPills.element(byAttr.css('li:nth-child(2)'))  .getAttribute('class').should.eventually.contain 'active'
    ## Check navbar dropdown
    elem.navShopBtn.element(byAttr.css('li:nth-child(1)'))   .getAttribute('class').should.eventually.equal 'ng-scope'
    elem.navShopBtn.element(byAttr.css('li:nth-child(2)'))   .getAttribute('class').should.eventually.contain 'active'


  describe 'changing and updating store', () ->

    xit 'should rearrange products', () ->

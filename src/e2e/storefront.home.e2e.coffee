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

describe 'eeosk storefront.home', () ->

  before (done) ->
    offscreen = element byAttr.css '#ee-offscreen'
    onscreen  = element byAttr.css '#ee-main'
    elem =
      loginBtn:               onscreen.element byAttr.cssContainingText('.btn', 'Login')

      homeBtn:                offscreen.element byAttr.cssContainingText('.btn', 'Home')
      shopBtn:                offscreen.element byAttr.cssContainingText('.btn', 'Shop')
      blogBtn:                offscreen.element byAttr.cssContainingText('.btn', 'Blog')
      aboutBtn:               offscreen.element byAttr.cssContainingText('.btn', 'About')
      socialBtn:              offscreen.element byAttr.cssContainingText('.btn', 'Social')

      alert:                  element byAttr.css  '.alert'
      save:                   element byAttr.name 'save'
      navbar:                 element byAttr.css  '.navbar.navbar-rgba-colors'
      navbarBrand:            element byAttr.css  '.navbar .navbar-header .navbar-brand'
      carouselImg:            element byAttr.css  '.carousel img'
      carouselWell:           element byAttr.css  '.carousel .position-absolute'
      carouselWellH3:         element byAttr.css  '.carousel .well h3'
      carouselWellP:          element byAttr.css  '.carousel .well p'
      carouselWellA:          element byAttr.css  '.carousel .well a'

      topBarColor:            offscreen.element byAttr.name 'storefront_meta.home.topBarColor'
      topBarBackgroundColor:  offscreen.element byAttr.name 'storefront_meta.home.topBarBackgroundColor'
      name:                   offscreen.element byAttr.model 'user.storefront_meta.home.name'
      carouselHeadline:       offscreen.element byAttr.model 'user.storefront_meta.home.carousel[0].headline'
      carouselByline:         offscreen.element byAttr.model 'user.storefront_meta.home.carousel[0].byline'
      carouselBtnText:        offscreen.element byAttr.model 'user.storefront_meta.home.carousel[0].btnText'
      carouselBtnPosition:    offscreen.element byAttr.css '#ee-offscreen-child .btn-group'
      carouselLinkCategory:   offscreen.element byAttr.model 'user.storefront_meta.home.carousel[0].linkCategory'

    newVal =
      topBarColor:            '#FFF'
      topBarBackgroundColor:  '#000000'
      name:                   'New Name'
      carouselHeadline:       'New Headline'
      carouselByline:         'New Byline'
      carouselBtnText:        'New Button'

    utils.reset_and_login(browser)
    .then (res) ->
      scope = res
      scope.categories = ['All'].concat _.unique(_.pluck scope.products, 'category')

  it 'should visit the storefront home on login', () ->
    elem.loginBtn             .click()
    browser                   .getTitle().should.eventually.equal 'Build your store | eeosk'

  it 'should reflect changes to the store name', () ->
    elem.name                 .getAttribute('value').should.eventually.equal ''
    elem.navbarBrand          .getText().should.eventually.equal ''
    elem.name                 .clear().sendKeys newVal.name
    elem.navbarBrand          .getText().should.eventually.equal newVal.name

  it 'should reflect changes to the navbar colors', () ->
    topBarRgb             =   utils.hex_to_rgb scope.user.storefront_meta.home.topBarColor
    topBarBackgroundRgb   =   utils.hex_to_rgb scope.user.storefront_meta.home.topBarBackgroundColor
    elem.navbarBrand          .getAttribute('style').should.eventually.contain topBarRgb
    elem.navbar               .getAttribute('style').should.eventually.contain topBarBackgroundRgb
    elem.topBarColor          .clear().sendKeys newVal.topBarColor
    elem.topBarBackgroundColor.clear().sendKeys newVal.topBarBackgroundColor
    elem.navbarBrand          .getAttribute('style').should.eventually.contain 'color: rgb(0, 0, 0)'
    elem.navbar               .getAttribute('style').should.eventually.contain 'background-color: rgb(255, 255, 255)'

  it 'should reflect changes to the carousel', () ->
    elem.carouselHeadline     .getAttribute('value').should.eventually.equal 'Lorem Ipsum'
    elem.carouselHeadline     .clear().sendKeys newVal.carouselHeadline
    elem.carouselHeadline     .getAttribute('value').should.eventually.equal newVal.carouselHeadline

    elem.carouselByline       .getAttribute('value').should.eventually.equal 'Dolores Sunt Amet'
    elem.carouselByline       .clear().sendKeys newVal.carouselByline
    elem.carouselByline       .getAttribute('value').should.eventually.equal newVal.carouselByline

    elem.carouselBtnText      .getAttribute('value').should.eventually.equal 'Shop Now'
    elem.carouselBtnText      .clear().sendKeys newVal.carouselBtnText
    elem.carouselBtnText      .getAttribute('value').should.eventually.equal newVal.carouselBtnText

    elem.carouselBtnPosition  .all(byAttr.css('.btn')).get(0).click()
    elem.carouselWell         .getAttribute('class').should.eventually.contain 'left'
    elem.carouselBtnPosition  .all(byAttr.css('.btn')).get(2).click()
    elem.carouselWell         .getAttribute('class').should.eventually.contain 'right'
    elem.carouselBtnPosition  .all(byAttr.css('.btn')).get(1).click()
    elem.carouselWell         .getAttribute('class').should.eventually.contain 'middle'

    elem.carouselLinkCategory .getAttribute('value').should.eventually.equal scope.categories[0]
    elem.carouselLinkCategory .element(byAttr.css('option:nth-child(2)')).click()
    elem.carouselLinkCategory .getAttribute('value').should.eventually.equal scope.categories[1]

  it 'should have saved the changes that were made', () ->
    elem.save                 .click()
    browser.get '/storefront/home'
    elem.carouselHeadline     .getAttribute('value').should.eventually.equal newVal.carouselHeadline
    elem.carouselByline       .getAttribute('value').should.eventually.equal newVal.carouselByline
    elem.carouselBtnText      .getAttribute('value').should.eventually.equal newVal.carouselBtnText
    elem.carouselWell         .getAttribute('class').should.eventually.contain 'middle'
    elem.carouselLinkCategory .getAttribute('value').should.eventually.equal scope.categories[1]
    elem.navbarBrand          .getText().should.eventually.equal newVal.name
    elem.navbarBrand          .getAttribute('style').should.eventually.contain 'color: rgb(0, 0, 0)'
    elem.navbar               .getAttribute('style').should.eventually.contain 'background-color: rgb(255, 255, 255)'

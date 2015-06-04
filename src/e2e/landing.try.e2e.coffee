process.env.NODE_ENV = 'test'
utils           = require './utils.e2e.db'
chai            = require 'chai'
expect          = require('chai').expect
should          = chai.should()
chaiAsPromised  = require 'chai-as-promised'
chai.use chaiAsPromised
_               = require 'lodash'

elem    = {}
oldVal  = {}
newVal  = {}
scope   = {}

describe 'eeosk landing.try', () ->

  before (done) ->
    bottom = element byAttr.css '#ee-bottom-view'

    elem =
      body:                   element byAttr.css 'body'
      form:                   bottom.element byAttr.css 'form.form-horizontal'
      tryBtn:                 bottom.element byAttr.cssContainingText '.btn', 'Try it out'
      saveBtn:                bottom.element byAttr.cssContainingText '.btn', 'Save'
      saveCancelBtn:          element byAttr.cssContainingText '.btn', 'cancel'
      addProductsBtn:         bottom.element byAttr.cssContainingText '.btn', 'Add Products'
      navbarBrand:            bottom.element byAttr.css  '.navbar .navbar-header .navbar-brand'
      navbar:                 bottom.element byAttr.css  '.navbar.navbar-rgba-colors'
      topBarBackgroundColor:  bottom.element byAttr.name 'storefront_meta.home.topBarBackgroundColor'
      topBarColor:            bottom.element byAttr.name 'storefront_meta.home.topBarColor'
      mainImageToggle:        bottom.element byAttr.name 'mainImageToggle'
      mainImageFive:          bottom.element byAttr.repeater('imgUrl in landing.data.defaultImages').row(4)
      carouselImage:          bottom.element byAttr.css  '#ee-bottom-view .carousel > img'
      name:                   bottom.element byAttr.model 'landing.storefront.storefront_meta.home.name'
      modalTitle:             element byAttr.css '.modal'

    oldVal =
      topBarColor:            '#021709'
      topBarBackgroundColor:  '#dbd6ff'
      topBarRgb:              utils.hex_to_rgb '#021709'
      topBarBackgroundRgb:    utils.hex_to_rgb '#dbd6ff'

    newVal =
      topBarColor:            '#135da1'
      topBarBackgroundColor:  '#ffffff'
      topBarRgb:              utils.hex_to_rgb '#135da1'
      topBarBackgroundRgb:    utils.hex_to_rgb '#ffffff'
      name:                   'New Name'

  it 'should show the try page', () ->
    browser.get '/'
    elem.tryBtn               .click()
    browser                   .getTitle().should.eventually.contain 'Try it out'
    elem.form                 .getText().should.eventually.contain 'OK, let\'s build your store!'
    elem.form                 .getText().should.eventually.contain 'Click to change your store\'s top bar color'

  it 'should progress through top bar color selection', () ->
    elem.navbarBrand          .getAttribute('style').should.eventually.contain oldVal.topBarRgb
    elem.navbar               .getAttribute('style').should.eventually.contain oldVal.topBarBackgroundRgb
    elem.topBarColor          .click()
    elem.form                 .getText().should.not.eventually.contain 'Click to change your store\'s top bar color'
    elem.topBarColor          .clear().sendKeys newVal.topBarColor
    elem.body                 .click()
    elem.form                 .getText().should.eventually.contain 'Click to change your store\'s top bar font color'
    elem.topBarBackgroundColor.click()
    elem.form                 .getText().should.not.eventually.contain 'Click to change your store\'s top bar font color'
    elem.topBarBackgroundColor.clear().sendKeys newVal.topBarBackgroundColor
    elem.body                 .click()
    elem.navbarBrand          .getAttribute('style').should.eventually.contain 'color: rgb(255, 255, 255)'
    elem.navbar               .getAttribute('style').should.eventually.contain 'background-color: rgb(19, 93, 161)'

  it 'should progress through carousel image selection', () ->
    elem.carouselImage        .getAttribute('class').should.eventually.contain 'max-height-0'
    elem.mainImageToggle      .click()
    elem.mainImageFive        .click()
    elem.carouselImage        .getAttribute('class').should.eventually.contain 'max-height-2400'
    elem.carouselImage        .getAttribute('src').should.eventually.contain 'https://res.cloudinary.com/eeosk/image/upload'

  it 'should progress through title entry', () ->
    elem.name                 .element(byAttr.xpath('..')).getText().should.eventually.contain 'Great!\nNow choose your store title\n(you can change later or skip this)'
    elem.body                 .getText().should.not.eventually.contain 'Looking good!'
    elem.addProductsBtn       .isDisplayed().should.eventually.equal false
    elem.name                 .clear().sendKeys newVal.name
    elem.navbarBrand          .getText().should.eventually.contain newVal.name

  it 'should show Add Products button after 2 seconds', () ->
    browser.sleep 1500
    .then () ->
      elem.body               .getText().should.eventually.contain 'Looking good!'
      elem.addProductsBtn     .isDisplayed().should.eventually.equal true

  it 'should show signup modal when button is clicked', () ->
    elem.saveBtn              .click()
    browser                   .waitForAngular()
    browser                   .executeScript("$('.modal').removeClass('fade');")
    element(byAttr.css('.modal')).getText().should.eventually.contain 'Save & continue'
    elem.saveCancelBtn        .click()
    browser                   .waitForAngular()
    browser                   .executeScript("$('.modal').removeClass('fade');")

  it 'should go to the Add Products page when button is clicked', () ->
    elem.addProductsBtn       .click()
    browser.sleep 1500
    .then () ->
      element(byAttr.css('#ee-top-view')).getText().should.eventually.contain 'Add products below'

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

describe 'eeosk storefront.blog', () ->

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
      blogInput:              offscreen.element byAttr.model 'user.storefront_meta.blog.url'

      navBlogBtn:             navbar.element byAttr.css 'ul.nav.navbar-nav:nth-child(1) > li:nth-child(3)'
      popover:                navbar.element byAttr.css 'ul.nav.navbar-nav:nth-child(1) > li:nth-child(3) .popover'
      popContent:             navbar.element byAttr.css 'ul.nav.navbar-nav:nth-child(1) > li:nth-child(3) .popover > .popover-content > div'

    newVal =
      blog:                   'http://localhost:5555/v0/status'

    utils.reset_and_login(browser)
    .then (res) ->
      scope = res
      scope.categories = ['All'].concat _.unique(_.pluck scope.products, 'category')

  it 'should hide the blog button when not in use', () ->
    elem.loginBtn             .click()
    elem.navBlogBtn           .getAttribute('class').should.eventually.equal 'ng-hide'

  it 'should have the proper title', () ->
    elem.blogBtn              .click()
    browser.getTitle()        .should.eventually.equal 'Build your store | eeosk'

  it 'show the initial button and popover', () ->
    elem.navBlogBtn           .getAttribute('class').should.eventually.equal 'active'
    elem.popContent           .getText().should.eventually.contain 'Enter the link to your blog and'

  it 'add a blog', () ->
    elem.blogInput            .clear().sendKeys newVal.blog
    elem.popContent           .getText().should.eventually.contain 'Customers will be directed to'
    elem.popContent           .element(byAttr.css('a')).getAttribute('href').should.eventually.contain newVal.blog

  it 'save a blog', () ->
    elem.save                 .click()
    browser                   .refresh()
    elem.popContent           .getText().should.eventually.contain 'Customers will be directed to'
    elem.popContent           .element(byAttr.css('a')).getAttribute('href').should.eventually.contain newVal.blog

  it 'visit a blog', () ->
    elem.popContent           .element(byAttr.css('a')).click()
    browser                   .getAllWindowHandles()
    .then (handles) ->
      browser.driver          .switchTo().window(handles[1])
      # browser.driver        .sleep(300)
      browser.driver          .getCurrentUrl().should.eventually.contain newVal.blog

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

describe 'eeosk storefront.audience', () ->

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
      facebookInput:          offscreen.element byAttr.model 'user.storefront_meta.audience.social.facebook'
      pinterestInput:         offscreen.element byAttr.model 'user.storefront_meta.audience.social.pinterest'
      twitterInput:           offscreen.element byAttr.model 'user.storefront_meta.audience.social.twitter'
      instagramInput:         offscreen.element byAttr.model 'user.storefront_meta.audience.social.instagram'
      emailInput:             offscreen.element byAttr.model 'user.storefront_meta.audience.contact.email'

      navSocialBtn:           navbar.element byAttr.css 'ul.nav.navbar-nav:nth-child(2) > li:nth-child(1)'
      popover:                navbar.element byAttr.css 'ul.nav.navbar-nav:nth-child(2) > li:nth-child(1) .popover'
      popContent:             navbar.element byAttr.css 'ul.nav.navbar-nav:nth-child(2) > li:nth-child(1) .popover > .popover-content'

      facebook:               onscreen.element byAttr.binding 'user.storefront_meta.audience.social.facebook'
      pinterest:              onscreen.element byAttr.binding 'user.storefront_meta.audience.social.pinterest'
      twitter:                onscreen.element byAttr.binding 'user.storefront_meta.audience.social.twitter'
      instagram:              onscreen.element byAttr.binding 'user.storefront_meta.audience.social.instagram'
      email:                  onscreen.element byAttr.binding 'user.storefront_meta.audience.contact.email'

    newVal =
      facebook:               'myFacebook'
      pinterest:              'myPinterest'
      twitter:                'myTwitter'
      instagram:              'myInstagram'
      email:                  'my.email@foo.bar'

    utils.reset_and_login(browser)
    .then (res) ->
      scope = res

  it 'should hide the audience button when not in use', () ->
    elem.loginBtn             .click()
    elem.navSocialBtn         .getAttribute('class').should.eventually.equal 'ng-hide'

  it 'should have the proper title', () ->
    elem.socialBtn            .click()
    browser.getTitle()        .should.eventually.equal 'Build your store | eeosk'

  it 'show the initial button and popover', () ->
    elem.navSocialBtn         .getAttribute('class').should.eventually.equal ''
    elem.popContent           .getText().should.eventually.contain 'Add your social media'

  it 'add social media', () ->
    elem.facebookInput        .sendKeys newVal.facebook
    elem.pinterestInput       .sendKeys newVal.pinterest
    elem.twitterInput         .sendKeys newVal.twitter
    elem.instagramInput       .sendKeys newVal.instagram
    elem.facebook             .getText().should.eventually.equal 'facebook.com/' + newVal.facebook
    elem.pinterest            .getText().should.eventually.equal 'pinterest.com/' + newVal.pinterest
    elem.twitter              .getText().should.eventually.equal 'twitter.com/' + newVal.twitter
    elem.instagram            .getText().should.eventually.equal 'instagram.com/' + newVal.instagram

  it 'add email', () ->
    elem.emailInput           .sendKeys newVal.email
    elem.email                .getText().should.eventually.equal newVal.email

  it 'save social media and email', () ->
    elem.save.click()
    browser.refresh()
    elem.facebook             .getText().should.eventually.equal 'facebook.com/' + newVal.facebook
    elem.pinterest            .getText().should.eventually.equal 'pinterest.com/' + newVal.pinterest
    elem.twitter              .getText().should.eventually.equal 'twitter.com/' + newVal.twitter
    elem.instagram            .getText().should.eventually.equal 'instagram.com/' + newVal.instagram
    elem.email                .getText().should.eventually.equal newVal.email

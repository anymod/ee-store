_       = require 'lodash'
sources = {}

stripSrc  = (arr) -> _.map arr, (str) -> str.replace('./src/', '')
toJs      = (arr) -> _.map arr, (str) -> str.replace('.coffee', '.js').replace('./src/', 'js/')
unmin     = (arr) ->
  _.map arr, (str) -> str.replace('dist/angulartics', 'src/angulartics').replace('.min.js', '.js')

sources.storeJs = () ->
  [].concat stripSrc(unmin(sources.storeVendorMin))
    .concat stripSrc(sources.storeVendorUnmin)
    .concat toJs(sources.appModule)
    .concat toJs(sources.storeModule)
    .concat toJs(sources.storeDirective)

sources.storeModules = () ->
  [].concat sources.appModule
    .concat sources.storeModule
    .concat sources.storeDirective

### VENDOR ###
sources.storeVendorMin = [
  './src/bower_components/angular/angular.min.js'
  './src/bower_components/angular-sanitize/angular-sanitize.min.js'
  './src/bower_components/angular-cookies/angular-cookies.min.js'
  './src/bower_components/angular-bootstrap/ui-bootstrap.min.js'
  './src/bower_components/angular-bootstrap/ui-bootstrap-tpls.min.js'
  './src/bower_components/angular-ui-router/release/angular-ui-router.min.js'
  './src/bower_components/angulartics/dist/angulartics.min.js'
  './src/bower_components/angulartics/dist/angulartics-ga.min.js'
]
sources.storeVendorUnmin = []

### MODULE ###
sources.appModule = [
  # Definitions
  './src/ee-shared/core/core.module.coffee'
  './src/ee-shared/core/constants.coffee'
  './src/ee-shared/core/filters.coffee'
  './src/ee-shared/core/config.coffee'
  './src/ee-shared/core/run.coffee'
  # Services
  # './src/ee-shared/core/svc.back.coffee'
  # './src/ee-shared/core/svc.storefront.coffee'
  # './src/ee-shared/core/svc.product.coffee'
  './src/ee-shared/core/svc.modal.coffee'
  # './src/ee-shared/core/svc.definer.coffee'
  './src/ee-shared/core/svc.selections.coffee'
  # Product modal
  # './src/ee-shared/product/product.modal.controller.coffee'
]
sources.storeModule = [
  # Definitions
  './src/store/store.index.coffee'
  './src/store/core/core.module.coffee'
  './src/store/core/run.coffee'
  './src/store/core/store.config.coffee'
  './src/store/core/core.route.coffee'
  # Services
  './src/store/core/svc.auth.coffee'
  './src/store/core/svc.back.coffee'
  './src/store/core/svc.cart.coffee'
  './src/store/core/svc.landing.coffee'
  './src/store/core/svc.fetcher.coffee'
  # Module - store
  './src/store/store.controller.coffee'
  # Module - selection
  './src/store/selection.controller.coffee'
  # Module - cart
  './src/store/cart.controller.coffee'
]

### DIRECTIVES ###
sources.storeDirective = [
  './src/ee-shared/components/ee-button-add-to-cart.coffee'
  './src/ee-shared/components/ee-selection-for-storefront.coffee'
  './src/ee-shared/components/ee-selection-card.coffee'
  './src/ee-shared/components/ee-shop-nav.coffee'
  './src/ee-shared/components/ee-storefront-header.coffee'
  './src/ee-shared/components/ee-scroll-to-top.coffee'
]

module.exports = sources

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
  # TODO remove once zoom.js gone
  './src/bower_components/jquery/dist/jquery.min.js'
  './src/bower_components/angular/angular.min.js'
  './src/bower_components/angular-ui-router/release/angular-ui-router.min.js'
  # './src/bower_components/angular-sanitize/angular-sanitize.min.js'
  './src/bower_components/angular-cookies/angular-cookies.min.js'
  './src/bower_components/angular-animate/angular-animate.min.js'
  './src/bower_components/angular-bootstrap/ui-bootstrap.min.js'
  './src/bower_components/angular-bootstrap/ui-bootstrap-tpls.min.js'
  './src/bower_components/angulartics/dist/angulartics.min.js'
  './src/bower_components/angulartics-google-analytics/dist/angulartics-google-analytics.min.js'
  './src/bower_components/zoom.js/dist/zoom.min.js'
  './src/bower_components/keen-js/dist/keen.min.js'
]
sources.storeVendorUnmin = [
  # TODO remove once zoom.js gone
  './src/bower_components/bootstrap/js/transition.js'
]

### MODULE ###
sources.appModule = [
  # Definitions
  './src/ee-shared/core/core.module.coffee'
  './src/ee-shared/core/constants.coffee'
  './src/ee-shared/core/filters.coffee'
  './src/ee-shared/core/config.coffee'
  './src/ee-shared/core/run.coffee'
  # Services
  './src/ee-shared/core/svc.modal.coffee'
]
sources.storeModule = [
  # Definitions
  './src/store/store.index.coffee'
  './src/store/core/core.module.coffee'
  './src/store/core/run.coffee'
  './src/store/core/store.config.coffee'
  './src/store/core/core.route.coffee'
  # Services
  './src/store/core/svc.back.coffee'
  './src/store/core/svc.user.coffee'
  './src/store/core/svc.product.coffee'
  './src/store/core/svc.products.coffee'
  './src/store/core/svc.collection.coffee'
  './src/store/core/svc.collections.coffee'
  './src/store/core/svc.definer.coffee'
  './src/store/core/svc.cart.coffee'
  # Module - store
  './src/store/store.controller.coffee'
  # Module - home
  './src/store/home/home.module.coffee'
  './src/store/home/home.route.coffee'
  './src/store/home/home.controller.coffee'
  # Module - collection
  './src/store/collections/collections.module.coffee'
  './src/store/collections/collections.route.coffee'
  './src/store/collections/collection.controller.coffee'
  './src/store/collections/collections.controller.coffee'
  # Module - categories
  './src/store/categories/categories.module.coffee'
  './src/store/categories/categories.route.coffee'
  './src/store/categories/category.controller.coffee'
  # Module - product
  './src/store/product/product.module.coffee'
  './src/store/product/product.route.coffee'
  './src/store/product/product.controller.coffee'
  # Module - cart
  './src/store/cart/cart.module.coffee'
  './src/store/cart/cart.route.coffee'
  './src/store/cart/cart.controller.coffee'
  # Module - help
  './src/store/help/help.module.coffee'
  './src/store/help/help.route.coffee'
  './src/store/help/help.controller.coffee'
  # Module - search
  './src/store/search/search.module.coffee'
  './src/store/search/search.route.coffee'
  './src/store/search/search.controller.coffee'
  # Module - modal
  './src/store/modal/modal.controller.coffee'
]

### DIRECTIVES ###
sources.storeDirective = [
  './src/ee-shared/components/ee-button-add-to-cart.coffee'
  './src/ee-shared/components/ee-product-for-store.coffee'
  './src/ee-shared/components/ee-product-card.coffee'
  './src/ee-shared/components/ee-collection-nav.coffee'
  './src/ee-shared/components/ee-collection-for-store.coffee'
  './src/ee-shared/components/ee-storefront-header.coffee'
  './src/ee-shared/components/ee-storefront-scroller.coffee'
  './src/ee-shared/components/ee-storefront-logo.coffee'
  './src/ee-shared/components/ee-storefront-brand.coffee'
  './src/ee-shared/components/ee-scroll-to-top.coffee'
  './src/ee-shared/components/ee-product-images.coffee'
  './src/ee-shared/components/ee-empty-message.coffee'
  './src/ee-shared/components/ee-loading.coffee'
]

module.exports = sources

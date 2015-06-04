_       = require 'lodash'
sources = {}

stripSrc  = (arr) -> _.map arr, (str) -> str.replace('./src/', '')
toJs      = (arr) -> _.map arr, (str) -> str.replace('.coffee', '.js').replace('./src/', 'js/')
unmin     = (arr) ->
  _.map arr, (str) -> str.replace('dist/angulartics', 'src/angulartics').replace('.min.js', '.js')

sources.builderJs = () ->
  [].concat stripSrc(unmin(sources.builderVendorMin))
    .concat stripSrc(sources.builderVendorUnmin)
    .concat toJs(sources.appModule)
    .concat toJs(sources.builderModule)
    .concat toJs(sources.builderDirective)

sources.storeJs = () ->
  [].concat stripSrc(unmin(sources.storeVendorMin))
    .concat stripSrc(sources.storeVendorUnmin)
    .concat toJs(sources.appModule)
    .concat toJs(sources.storeModule)
    .concat toJs(sources.storeDirective)

sources.builderModules = () ->
  [].concat sources.appModule
    .concat sources.builderModule
    .concat sources.builderDirective

sources.storeModules = () ->
  [].concat sources.appModule
    .concat sources.storeModule
    .concat sources.storeDirective

### VENDOR ###
sources.builderVendorMin = [
  # TODO remove once cloudinary jQuery upload is gone
  './src/bower_components/jquery/dist/jquery.min.js'
  './src/bower_components/angular/angular.min.js'
  './src/bower_components/angular-sanitize/angular-sanitize.min.js'
  './src/bower_components/angular-ui-router/release/angular-ui-router.min.js'
  './src/bower_components/angular-cookies/angular-cookies.min.js'
  './src/bower_components/angulartics/dist/angulartics.min.js'
  './src/bower_components/angulartics/dist/angulartics-ga.min.js'
  './src/bower_components/angular-bootstrap/ui-bootstrap.min.js'
  './src/bower_components/angular-bootstrap/ui-bootstrap-tpls.min.js'
  './src/bower_components/angular-bootstrap-colorpicker/js/bootstrap-colorpicker-module.min.js'
  './src/bower_components/angular-scroll/angular-scroll.min.js'
]
sources.builderVendorUnmin = [
  './src/bower_components/cloudinary/js/jquery.ui.widget.js'
  './src/bower_components/cloudinary/js/jquery.iframe-transport.js'
  './src/bower_components/cloudinary/js/jquery.fileupload.js'
  './src/bower_components/jquery.cloudinary.1.0.21.js'
]
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
sources.storeVendorUnmin = [

]

### MODULE ###
sources.appModule = [
  # Definitions
  './src/app/core/core.module.coffee'
  './src/app/core/constants.coffee'
  './src/app/core/filters.coffee'
  './src/app/core/config.coffee'
  './src/app/core/run.coffee'
  # Services
  './src/app/core/svc.back.coffee'
  './src/app/core/svc.storefront.coffee'
  './src/app/core/svc.product.coffee'
  './src/app/core/svc.modal.coffee'
  './src/app/core/svc.definer.coffee'
  # Product modal
  './src/app/product/product.modal.controller.coffee'
]
sources.builderModule = [
  # Definitions
  './src/builder/builder.index.coffee'
  './src/builder/core/core.module.coffee'
  './src/builder/core/run.coffee'
  # Services
  './src/builder/core/svc.auth.coffee'
  './src/builder/core/svc.cart.coffee'
  './src/builder/core/svc.catalog.coffee'
  './src/builder/core/svc.landing.coffee'
  './src/builder/core/svc.orders.coffee'
  './src/builder/core/svc.selection.coffee'
  # Module - auth
  './src/builder/auth/auth.module.coffee'
  # auth.login
  './src/builder/auth.login/auth.login.route.coffee'
  './src/builder/auth.login/auth.login.controller.coffee'
  # auth.logout
  './src/builder/auth.logout/auth.logout.route.coffee'
  './src/builder/auth.logout/auth.logout.controller.coffee'
  # auth.reset
  './src/builder/auth.reset/auth.reset.route.coffee'
  './src/builder/auth.reset/auth.reset.controller.coffee'
  # Contact
  './src/builder/contact/contact.module.coffee'
  './src/builder/contact/contact.controller.coffee'
  # Module - landing
  './src/builder/landing/landing.module.coffee'
  './src/builder/landing/landing.route.coffee'
  './src/builder/landing/landing.controller.coffee'
  # Module - example
  './src/builder/example/example.module.coffee'
  './src/builder/example/example.route.coffee'
  './src/builder/example/example.controller.coffee'
  # Module - go
  './src/builder/go/go.module.coffee'
  './src/builder/go/go.route.coffee'
  './src/builder/go/go.controller.coffee'
  # Module - is
  './src/builder/is/is.module.coffee'
  './src/builder/is/is.route.coffee'
  './src/builder/is/is.controller.coffee'
  # Module - create
  './src/builder/create/create.module.coffee'
  './src/builder/create/create.route.coffee'
  './src/builder/create/create.controller.coffee'
  # Module - edit
  './src/builder/edit/edit.module.coffee'
  './src/builder/edit/edit.route.coffee'
  './src/builder/edit/edit.controller.coffee'
  # Module - terms
  './src/builder/terms/terms.module.coffee'
  './src/builder/terms/terms.route.coffee'
  './src/builder/terms/terms.controller.coffee'
  './src/builder/terms/terms.modal.controller.coffee'
  # Module - storefront
  './src/builder/storefront/storefront.module.coffee'
  './src/builder/storefront/storefront.route.coffee'
  './src/builder/storefront/storefront.controller.coffee'
  # Module - catalog
  './src/builder/catalog/catalog.module.coffee'
  './src/builder/catalog/catalog.route.coffee'
  './src/builder/catalog/catalog.controller.coffee'
  # Module - orders
  './src/builder/orders/orders.module.coffee'
  './src/builder/orders/orders.route.coffee'
  './src/builder/orders/orders.controller.coffee'
  # Module - account
  './src/builder/account/account.module.coffee'
  './src/builder/account/account.route.coffee'
  './src/builder/account/account.controller.coffee'
]
sources.storeModule = [
  # Definitions
  './src/store/store.index.coffee'
  './src/store/core/core.module.coffee'
  './src/store/core/run.coffee'
  './src/store/core/core.route.coffee'
  # Services
  './src/store/core/svc.auth.coffee'
  './src/store/core/svc.cart.coffee'
  './src/store/core/svc.landing.coffee'
  # Module - store
  './src/store/store.controller.coffee'
  # Module - cart
  './src/store/cart.controller.coffee'
]

### DIRECTIVES ###
sources.builderDirective = [
  './src/components/ee-terms-seller.coffee'
  './src/components/ee-terms-privacy.coffee'
  './src/components/ee-navbar.coffee'
  './src/components/ee-product.coffee'
  './src/components/ee-product-for-storefront.coffee'
  './src/components/ee-save.coffee'
  './src/components/ee-shop-nav.coffee'
  './src/components/ee-order.coffee'
  './src/components/ee-cloudinary-upload.coffee'
  './src/components/ee-image-preload.coffee'
  './src/components/ee-storefront-header.coffee'
  './src/components/ee-scroll-to-top.coffee'
]
sources.storeDirective = [
  './src/components/ee-button-add-to-cart.coffee'
  './src/components/ee-product.coffee'
  './src/components/ee-product-for-storefront.coffee'
  './src/components/ee-shop-nav.coffee'
  './src/components/ee-storefront-header.coffee'
  './src/components/ee-scroll-to-top.coffee'
]

module.exports = sources

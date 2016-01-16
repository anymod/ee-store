'use strict'

angular.module 'eeStore', [
  # vendor
  'ngCookies'
  'ngAnimate'
  'ui.router'
  'ui.bootstrap'
  # 'ngSanitize'
  # 'angulartics'
  # 'angulartics.google.analytics'

  # core
  'app.core'

  # store
  'store.core'
  'store.collections'
  'store.categories'
  'store.help'
  'store.search'

  # custom
  'ee-storefront-header'
  'ee-storefront-logo'
  'ee-storefront-brand'
  'ee-scroll-to-top'
  'ee-collection-nav'
  'ee-product-for-store'
  'ee-product-card'
  'ee-product-images'
  'ee-empty-message'
  'ee-loading'
  # 'ee.templates' # commented out during build step for inline templates
]

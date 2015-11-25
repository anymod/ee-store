'use strict'

angular.module 'eeStore', [
  # vendor
  'ui.router'
  'ui.bootstrap'
  'ngCookies'
  'ngSanitize'
  'angulartics'
  'angulartics.google.analytics'

  # core
  'app.core'

  # store
  'store.core'
  'store.categories'
  'store.search'

  # custom
  'ee-storefront-header'
  'ee-storefront-logo'
  'ee-collection-nav'
  'ee-product-for-store'
  'ee-product-card'
  'ee-product-images'
  'ee-empty-message'
  # 'ee.templates' # commented out during build step for inline templates
]

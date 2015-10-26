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

  # custom
  'ee-storefront-header'
  'ee-collection-nav'
  'ee-product-for-store'
  'ee-product-card'
  'ee-product-images'
  # 'ee.templates' # commented out during build step for inline templates
]

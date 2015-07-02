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
  'ee-shop-nav'
  'ee-selection-for-storefront'
  'ee-selection-card'
  # 'ee.templates' # commented out during build step for inline templates
]

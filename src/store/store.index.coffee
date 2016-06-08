'use strict'

angular.module 'eeStore', [
  # vendor
  'ngCookies'
  'ngAnimate'
  'ui.router'
  'ui.bootstrap'
  # 'ngSanitize'
  'angulartics'
  'angulartics.google.analytics'

  # core
  'app.core'

  # store
  'store.core'
  'store.home'
  'store.collections'
  'store.categories'
  'store.product'
  'store.cart'
  'store.help'
  'store.search'

  # custom
  'ee-storefront-announcement'
  'ee-storefront-header'
  'ee-storefront-scroller'
  'ee-storefront-brand'
  'ee-scroll-to-top'
  'ee-scroll-show'
  'ee-collection-nav'
  'ee-collection-for-store'
  'ee-product-for-store'
  'ee-product-card'
  'ee-product-images'
  'ee-search-sort'
  'ee-empty-message'
  'ee-loading'
  'ee-signup'
  # 'ee.templates' # commented out during build step for inline templates
]

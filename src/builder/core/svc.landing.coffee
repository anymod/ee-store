'use strict'

angular.module('builder.core').factory 'eeLanding', ($rootScope, $timeout, $modal) ->

  ## SETUP
  _userDefaults =
    storefront_meta:
      home:
        name: ''
        topBarBackgroundColor: '#dbd6ff'
        topBarColor: '#021709'
        carousel: [{ imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,g_center,h_400,w_1200/v1425250403/desk1.jpg' }]
      blog: { url: 'https://eeosk.com' }
      about: { headline: 'eeosk' }
      audience:
        social:
          facebook:   'facebook'
          pinterest:  'pinterest'
          twitter:    'twitter'
          instagram:  'instagram'

  _showDefaults =
    landing: content: true
    example: content: false
    popover:
      edit:     true
      catalog:  true

  _demoStores = [
    {
      name: 'Book'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,h_400,w_1200/v1425249778/book_.jpg'
      topBarBackgroundColor: '#fafce8'
      topBarColor: '#321b01'
    },{
      name: 'Brick'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,h_400,w_1200/v1425249925/brick.jpg'
      topBarBackgroundColor: '#824b4b'
      topBarColor: '#ffffff'
    },{
      name: 'Bridge'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,h_400,w_1200/v1425250980/brdge.jpg'
      topBarBackgroundColor: '#e5cdb3'
      topBarColor: '#1f1e1e'
    },{
      name: 'City'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,h_400,w_1200/v1425250064/city_.jpg'
      topBarBackgroundColor: '#fffae0'
      topBarColor: '#000000'
    },{
      name: 'Coffee'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,h_400,w_1200/v1425250130/cffee.jpg'
      topBarBackgroundColor: '#c98a4f'
      topBarColor: '#960000'
    },{
      name: 'Concert'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,h_400,w_1200/v1425250164/cncrt.jpg'
      topBarBackgroundColor: '#000000'
      topBarColor: '#dbf1ff'
    },{
      name: 'Desert'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,g_south,h_400,w_1200/v1425250332/dsert.jpg'
      topBarBackgroundColor: '#701600'
      topBarColor: '#ffffff'
    },{
      name: 'Desk'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,g_center,h_400,w_1200/v1425250403/desk1.jpg'
      topBarBackgroundColor: '#dad8d8'
      topBarColor: '#3d3d3d'
    },{
      name: 'Desk 2'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,h_400,w_1200/v1425250486/desk2.jpg'
      topBarBackgroundColor: '#321706'
      topBarColor: '#ffffff'
    },{
      name: 'Drops'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,h_400,w_1200/v1425250531/drops.jpg'
      topBarBackgroundColor: '#291e34'
      topBarColor: '#ffffff'
    },{
      name: 'Ferns'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,g_north,h_400,w_1200/v1425250561/ferns.jpg'
      topBarBackgroundColor: '#123a2d'
      topBarColor: '#f1eadf'
    },{
      name: 'Fish'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,g_center,h_400,w_1200/v1425250595/fish_.jpg'
      topBarBackgroundColor: '#eefcfb'
      topBarColor: '#001a33'
    },{
      name: 'Golden Light'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,g_center,h_400,w_1200/v1425250656/gldnl.jpg'
      topBarBackgroundColor: '#291205'
      topBarColor: '#fffdd6'
    },{
      name: 'Open Road'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,h_400,w_1200/v1425250720/oroad.jpg'
      topBarBackgroundColor: '#1a1e23'
      topBarColor: '#ffffff'
    },{
      name: 'Oranges'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,h_400,w_1200/v1425251056/orngs.jpg'
      topBarBackgroundColor: '#add8ff'
      topBarColor: '#b34b05'
    },{
      name: 'Purple Flowers'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,h_400,w_1200/v1425251082/prplf.jpg'
      topBarBackgroundColor: '#ebb8ff'
      topBarColor: '#000000'
    },{
      name: 'Raspberries'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,g_north,h_400,w_1200/v1425251100/raspb.jpg'
      topBarBackgroundColor: '#ffffff'
      topBarColor: '#000000'
    },{
      name: 'Speeding Cars'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,g_north,h_400,w_1200/v1425251183/spdcr.jpg'
      topBarBackgroundColor: '#242323'
      topBarColor: '#e6d5d1'
    },{
      name: 'Times Square'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,h_400,w_1200/v1425251208/tmsqr.jpg'
      topBarBackgroundColor: '#de423a'
      topBarColor: '#f2f3f1'
    },{
      name: 'Water and Sailboat'
      imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,h_400,w_1200/v1425251226/wslbt.jpg'
      topBarBackgroundColor: '#a80000'
      topBarColor: '#ffffff'
    }
  ]

  # Fisher–Yates shuffle algorithm
  _shuffleArray = (array) ->
    if !array then return
    m = array?.length
    t = i = null
    while (m)
      i = Math.floor(Math.random() * m--)
      t = array[m]
      array[m] = array[i]
      array[i] = t
    array

  ## PRIVATE EXPORT DEFAULTS
  _show = _showDefaults
  _data =
    demoStores: _shuffleArray _demoStores
    signup:
      product_selection: []

  ## PRIVATE FUNCTIONS
  _reset = () -> _show = _showDefaults

  _showLanding = ()     -> _show.landing.content = true
  _hideLanding = ()     -> _show.landing.content = false
  _showExample = ()     -> _show.example.content = true
  _hideExample = ()     -> _show.example.content = false
  _hidePopover = (name) -> _show.popover[name]   = false

  _scrollTop = () -> $rootScope.scrollTo 'body-top'

  _landingState = () ->
    _showLanding()
    _hideExample()
    _scrollTop()

  _themeState = () ->
    _hideLanding()
    _hideExample()
    _scrollTop()

  _exampleState = () ->
    _hideLanding()
    _showExample()
    _scrollTop()

  ## EXPORTS
  show: _show
  data: _data

  landingUser: _userDefaults

  fns:
    reset:        () -> _reset()
    showState:    (name) ->
      if name is 'landing'    then $timeout _landingState,  100
      if name is 'welcome'    then $timeout _landingState,  100
      if name is 'try-theme'  then $timeout _themeState,    200
      if name is 'example'    then $timeout _exampleState,  200

    hidePopover: (name) -> _hidePopover name

    selectProduct: (product, margin) ->
      _data.signup.product_selection.push {
        product_id:         product.id
        selling_price:      parseInt(product.baseline_price * (100 + margin)/100)
        shipping_price:     product.availability_meta.ship_cost
        title:              product.title
        content:            product.content
        content_meta:       product.content_meta
        image_meta:         product.image_meta
        availability_meta:  product.availability_meta
        category:           product.category
      }

    openExampleModal: () ->
      $modal.open({
        templateUrl: 'builder/example/example.modal.html'
        backdropClass: 'white-background opacity-08'
        size: 'sm'
      })

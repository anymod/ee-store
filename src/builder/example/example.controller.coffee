'use strict'

angular.module('builder.example').controller 'exampleCtrl', (eeLanding) ->

  this.ee = {}

  this.show = eeLanding.show

  this.openExampleModal = () ->
    eeLanding.fns.openExampleModal()
    return

  this.ee.meta =
    home:
      name: 'Home Accents'
      topBarBackgroundColor: '#83bec3'
      topBarColor: '#021709'
      carousel: [{
        imgUrl: 'https://res.cloudinary.com/eeosk/image/upload/c_fill,h_400,w_1200/v1425250064/city_.jpg'
        headline: 'Store demo'
        byline: 'This is an example of what\'s possible'
        btnText: 'Click anywhere to close'
        btnPosition: 'right'
      }]
    blog: { url: 'http://eeosk.com' }
    about: { headline: 'foobar' }
    audience:
      social:
        facebook:   'facebook'
        twitter:    'twitter'
        pinterest:  'pinterest'
        instagram:  'instagram'

  example_products = [
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429115333/hijrsxnoedec3uraxc51.jpg' }
      title: 'Classy Ceramic Garden Stool Open- Work Green'
      selling_price: 17000
    },
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429115296/uwrh6viymxdsbzvownny.jpg' }
      title: 'Mesmerizing Styled Glass Candle Holder'
      selling_price: 4000
    },
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429115310/liw9altlnsjdgi9iceyi.jpg' }
      title: 'Leather Mirror with Leather Finish and Brass Metallic Rivets'
      selling_price: 15000
    },
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429115317/td2znaggsqygklxzl9lx.jpg' }
      title: 'The Beautiful Wood Real Leather Magazine Holder'
      selling_price: 9000
    },
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429115300/sfo5fpintcaaivn4qep7.jpg' }
      title: 'Metal Wall Clock (24" Diameter)'
      selling_price: 5400
    },
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429115315/qxacopwjbkfg212wyzcy.jpg' }
      title: 'Global worldly wood metal wall panel'
      selling_price: 13500
    },
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429115173/l60quadwge0cvcir7rft.jpg' }
      title: 'Manhattans Coppice Exclusive Basket Dresser'
      selling_price: 22500
    },
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429115173/vndcqkccfxy46tlaiqmh.jpg' }
      title: 'Console with Additional Storage Capability and Brass Handles'
      selling_price: 18000
    },
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429115301/jhhn5wbenblqts2752ry.jpg' }
      title: 'Artistic Stars Decorative Wall Art Furnishings'
      selling_price: 3000
    },
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429115302/oh9cgsiuotyo4gorqvrs.jpg' }
      title: 'Wall Accent Mirrors- Metal Mirror 35"W, 34"H'
      selling_price: 10900
    },
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429115300/u1d5tqq0jlpbhrqz0kba.jpg' }
      title: 'A Pair of Poly Stone Sitting Labrador with Wooden Bookend'
      selling_price: 29000
    },
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429115332/b7kujwg6dqdnsosgx4yb.jpg' }
      title: 'Bulldog with Bow Tie in Resin'
      selling_price: 3899
    },
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429115296/bdes8xdnz2em7dy1dtxk.jpg' }
      title: 'Ceramic 16" Rooster in White Shade'
      selling_price: 4800
    },
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429115158/xgnhj4tes7m6shl3iqgb.jpg' }
      title: 'Adjustable Logan Metal Stool with Wood Seat'
      selling_price: 8900
    },
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429115614/ilkahrcliyf6tgja4hqr.jpg' }
      title: 'Maxam® Chrome Heavy-Duty Professional Juicer'
      selling_price: 6500
    },
    {
      image_meta: { main_image: url: 'https://res.cloudinary.com/eeosk/image/upload/c_pad,w_150,h_150/v1429114984/bcffxksjshooyqino7ys.jpg' }
      title: 'Dorado: Aristide Bruant dans son Cabaret (20 x 30 Framed Poster)'
      selling_price: 7000
    }
  ]

  ## For ngInclude partials
  this.ee.carousel           = this.ee.meta?.home?.carousel[0]
  this.ee.product_selection  = example_products
  this.ee.categories = [
    'All',
    'Home Accents',
    'Furniture',
    'Kitchen',
    'Artwork'
  ]

  return

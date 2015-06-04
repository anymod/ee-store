process.env.NODE_ENV = 'test'
utils = require './utils.e2e.db'
_     = require 'lodash'
argv  = require('yargs').argv

scope = {}

describe 'seed', () ->

  it 'should seed', () ->
    if argv.grep is 'seed'
      console.log "SEED"
      utils.reset_and_login browser
      .then () ->
        utils.create_products([21..50])

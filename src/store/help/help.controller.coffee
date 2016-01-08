'use strict'

angular.module('store.help').controller 'helpCtrl', (eeBootstrap) ->

  help = this

  help.ee =
    Collections:
      collections:  eeBootstrap?.collections
      nav:          eeBootstrap?.nav

  return

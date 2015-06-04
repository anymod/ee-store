'use strict'

angular.module('builder.orders').controller 'ordersCtrl', (eeDefiner, eeOrders, eeStorefront) ->

  this.ee = eeDefiner.exports
  
  this.fns  = {}
  this.data = {}

  this.orders = []

  return

###
  ./boot/resources.coffee
###

fs = require 'fs'
resource = require './resource'
routes = require '../app/routes'
_ = require 'underscore'

# load function, reads a directory of controllers and dynamically
# maps it to a route
exports.load = (app) ->
  fs.readdir 'app/controllers', (error, controllers) ->
    throw error if error
    for controller in controllers
      controller = controller.substr(0, controller.lastIndexOf('.')) # remove file extension
      resource.map app, controller # map the controller to the app

  # Analyzes custom routes in ./app/routes.coffee
  # and maps them to controller actions
  _.each routes, (route, name) ->
    if _.isObject route
      route.action = 'index' if route.action is undefined
      name_arr = name.split ' '
      if name_arr.length > 1
        route_name = name_arr[1]
        route_verb = name_arr[0]
      else
        route_name = name
        route_verb = 'get'
      controller = require "../app/controllers/#{route.controller}"
      if _.isFunction controller[route.action]
        app[route_verb] "#{route_name}", controller[route.action]
      # Handle middleware
      app[route_verb] "#{route_name}", fn for fn in controller[route.action] if _.isArray controller[route.action]
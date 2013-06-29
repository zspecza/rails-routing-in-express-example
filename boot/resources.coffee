###
  ./boot/resources.coffee
###

fs = require 'fs'
resource = require './resource'
_ = require 'underscore'

# load function, reads a directory of controllers and dynamically
# maps it to a route
exports.load = (app, controllers_path = 'app/controllers', routes = require('../app/routes')) ->
  fs.readdir controllers_path, (error, controllers) ->
    throw error if error
    for controller in controllers
      controller = controller.substr(0, controller.lastIndexOf('.')) # remove file extension
      resource.map app, controller, controllers_path # map the controller to the app

  # Analyzes custom routes in ./app/routes.coffee
  # and maps them to controller actions
  _.each routes, (route, name) ->
    if _.isObject route
      route.action = 'index' if route.action is undefined
      name_arr = name.split ' ' # convert route name to an array
      if name_arr.length > 1 # check if there are two words in the array
        route_name = name_arr[1]
        route_verb = name_arr[0]
      else
        route_name = name
        route_verb = 'get' # default to a GET request if there is no HTTP verb present in the array
      controller = require "../#{controllers_path}/#{route.controller}"
      # map the route to a controller action
      app[route_verb] "#{route_name}", controller[route.action] if _.isFunction controller[route.action]
      # Handle middleware
      app[route_verb] "#{route_name}", fn for fn in controller[route.action] if _.isArray controller[route.action]
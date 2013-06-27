fs = require 'fs'
resource = require './resource'
routes = require '../app/routes'
_ = require 'underscore'

exports.load = (app) ->
  fs.readdir 'app/controllers', (error, files) ->
    throw error if error
    for file in files
      file = file.substr(0, file.lastIndexOf('.'))
      resource.map app, file

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
      route_file = require "../app/controllers/#{route.controller}"
      app[route_verb] "#{route_name}", route_file[route.action]
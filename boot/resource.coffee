###
  ./boot/resource.coffee - provides default CRUD operation mapping for controller routes
###

_ = require 'underscore'

# Reference each HTTP verb with it's crud operation
mappings = [
  { action: 'index', verb: 'get' }
  { action: 'new', verb: 'get' }
  { action: 'create', verb: 'post' }
  { action: 'show', verb: 'get' }
  { action: 'edit', verb: 'get' }
  { action: 'update', verb: 'put' }
  { action: 'destroy', verb: 'delete' }
]

# map_route function dynamically generates 
# an app.<verb> call and callback for each controller
# route
map_route = (app, name, controller) ->
  for mapping in mappings
    unless controller[mapping.action] is undefined # if it's undefined, Express' "cannot GET /route" message appears
      switch mapping.action
        when 'index' or 'create' then route = "/#{name}"
        when 'show' or 'update' or 'destroy' then route = "/#{name}/:id"
        when 'edit' then route = "/#{name}/:id/edit"
        else route = "/#{name}/#{mapping.action}"
      # map the route to the controller
      app[mapping.verb](route, controller[mapping.action]) if _.isFunction(controller[mapping.action])
      # Handle middleware
      app[mapping.verb](route, fn for fn in controller[mapping.action]) if _.isArray(controller[mapping.action])

# map function calls map_route after requiring the controller
exports.map = (app, controller_name, controllers_path = 'app/controllers') ->
  controller = require "../#{controllers_path}/#{controller_name}"
  map_route app, controller_name, controller
  return controller
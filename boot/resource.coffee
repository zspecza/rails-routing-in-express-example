mappings = [
  { action: 'index', verb: 'get' }
  { action: 'new', verb: 'get' }
  { action: 'create', verb: 'post' }
  { action: 'show', verb: 'get' }
  { action: 'edit', verb: 'get' }
  { action: 'update', verb: 'put' }
  { action: 'destroy', verb: 'delete' }
]

map_route = (app, name, route) ->
  for mapping in mappings
    if route[mapping.action] isnt undefined
      switch mapping.action
        when 'index' or 'create' then route_name = "/#{name}"
        when 'show' then route_name = "/#{name}/:id"
        when 'edit' then route_name = "/#{name}/:id/edit"
        when 'update' then route_name = "/#{name}/:id/update"
        when 'destroy' then route_name = "#{name}/:id/destroy"
        else route_name = "/#{name}/#{mapping.action}"
      app[mapping.verb](route_name, route[mapping.action])

exports.map = (app, route_name) ->
  route_file = "../app/controllers/#{route_name}"
  route = require route_file
  map_route app, route_name, route
  return route
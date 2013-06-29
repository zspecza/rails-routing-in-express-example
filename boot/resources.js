// Generated by CoffeeScript 1.6.2
/*
  ./boot/resources.coffee
*/

var fs, resource, routes, _;

fs = require('fs');

resource = require('./resource');

routes = require('../app/routes');

_ = require('underscore');

exports.load = function(app) {
  fs.readdir('app/controllers', function(error, controllers) {
    var controller, _i, _len, _results;

    if (error) {
      throw error;
    }
    _results = [];
    for (_i = 0, _len = controllers.length; _i < _len; _i++) {
      controller = controllers[_i];
      controller = controller.substr(0, controller.lastIndexOf('.'));
      _results.push(resource.map(app, controller));
    }
    return _results;
  });
  return _.each(routes, function(route, name) {
    var controller, fn, name_arr, route_name, route_verb, _i, _len, _ref, _results;

    if (_.isObject(route)) {
      if (route.action === void 0) {
        route.action = 'index';
      }
      name_arr = name.split(' ');
      if (name_arr.length > 1) {
        route_name = name_arr[1];
        route_verb = name_arr[0];
      } else {
        route_name = name;
        route_verb = 'get';
      }
      controller = require("../app/controllers/" + route.controller);
      if (_.isFunction(controller[route.action])) {
        app[route_verb]("" + route_name, controller[route.action]);
      }
      if (_.isArray(controller[route.action])) {
        _ref = controller[route.action];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          fn = _ref[_i];
          _results.push(app[route_verb]("" + route_name, fn));
        }
        return _results;
      }
    }
  });
};

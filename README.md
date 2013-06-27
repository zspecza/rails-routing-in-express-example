An Example of Rails-esque Routing in Express.js
============

This is an example codebase on how to achieve Rails-like routing in Express.js. It is written in CoffeeScript, and relies only on Underscore.js for convenience. You can choose to not include Underscore in your own implementation, as this code base is not very large.
Seriously, it's only about 50 lines of code. Nothing complicated at all. :smile:

There are only two files doing all of this magical work: `boot/resource.coffee` and `boot/resources.coffee`.

## How does it work?

In `app.coffee`, a single line of code makes a call to the `resources` module's `load()` function, passing in the Express `app` object as a parameter:

```coffeescript
resources = require './boot/resources'
resources.load(app) # this is what starts the magic
```

This function then iterates over the `app/controllers` folder, requiring each controller before mapping it as a resource using the `resource` module's `map()` function.

This `map()` function also designates some empty boilerplate CRUD HTTP operation maps for `index`, `new`, `create`, `show`, `edit`, `update` and `delete`, respectively, so that writing out your controllers becomes an easy task.

Controllers go inside the `app/controllers` folder, and they look like this:

**app/controllers/posts.coffee**

```coffeescript
exports.index = (req, res) ->
  res.send 'A list of all posts.'

exports.new = (req, res) ->
  res.send 'A form to create a new post.'

exports.create = (req, res) ->
  res.send 'Creates a new post.'

exports.show = (req, res) ->
  res.send 'Show a single post.'

exports.edit = (req, res) ->
  res.send 'A form to edit an existing post.'

exports.update = (req, res) ->
  res.send 'Updates an existing post.'

exports.destroy = (req, res) ->
  res.send 'Deletes a post.'
```

The URL paths for each controller are handled automatically, so once you've got a controller like the one above, you can visit `http://localhost:5000/posts` or `http://localhost:5000/posts/new` and the resource mapper will map the address to the correct controller.

If an action on a controller does not exist or is not defined, you will get the standard `cannot <VERB> /<controller>` message from Express.

## Custom Routes

The `resources.load()` function does something else that is also a little bit special. Once it is done with the controllers, it examines a routes file for any custom routes. This file is where you can manually map certain URL's to different controller actions and HTTP verbs.

For example, if you had a `home.coffee` controller to serve an index page on your root ("/") route:

**app/controllers/home.coffee**

```coffeescript
exports.index = (req, res) ->
  res.send 'Welcome to my homepage!'
```

You could then map that action to the root route in `app/routes.coffee`:

```coffeescript
routes = {
  
  'get /': {
    controller: 'home'
    action: 'index'
  }

}

module.exports = routes
```

You could even write it out a little less verbose than that. Any custom route map will default to 'GET' if there is no verb present in the route object's name string, and if no action is specified, it will default to `index`:

```coffeescript
routes = {
  
  '/': {
    controller: 'home'
  }

}
```

Furthermore, this adds in support for custom named controller actions:

**app/controllers/user.coffee**

```coffeescript
exports.sayhello = (req, res) ->
  res.send "Hello, I'm a user!"
```

**app/routes.coffee**

```coffeescript
routes = {
  
  '/user/sayhello': {
    controller: 'user'
    action: 'sayhello'
  }

}
```

## Conclusion

Have a look at the source for `resource.coffee` and `resources.coffee` in the `boot` folder. It really _is_ that simple to set up if you want to keep your code a little bit more organized and not have loads of `app.<verb>` calls in your main application file. Remember, though, that this is a rather opinionated setup - there are no checks to make sure the files are in the right place or any checks for if the `routes` file is empty, but adding that in would be equally as trivial as setting this up in the first place. I hope you enjoyed finding out the solution to better organizing your routes as I did coding it. :smile:
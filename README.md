An Example of Rails-esque Routing in Express.js
============

## Prelude

So, you're working on your latest Express.js project, and everytime you want to add in a new route, you either add it to your `app.js` or `routes.js` file. Eventually, your file becomes an unmaintainable mixed mess of different routes and lacks a decent separation of concerns.

This is not pretty:

```coffeescript
app.post '/signup', (req, res) ->
  user = new User
    firstName: req.body.firstName
    lastName: req.body.lastName
    email: req.body.email
    password: req.body.password
  user.save (error) -> if error then res.send error else res.redirect '/'

app.post '/login', passport.authenticate 'local',
  successRedirect: '/'
  failureRedirect: '/oops'

app.get '/logout', (req, res) ->
  if req.isAuthenticated()
    do req.logout
    res.redirect '/'
  else
    res.send 'You were not logged in in the first place.'

# List all user's students
app.get '/students', (req, res) ->
  if req.isAuthenticated()
    Student.find parent: req.user._id, (error, students) ->
      res.send error if error
      res.render 'students/list',
      title: 'Students'
      students: students
  else
    res.send 'You need to be logged in to do that.'

# add a student to the list
app.post '/students', (req, res) ->
  if req.isAuthenticated()
    student = new Student
      firstName: req.body.firstName
      lastName: req.body.lastName
      parent: req.user._id
    student.save (error) ->
      res.send error if error
      res.redirect '/students'
```

There's a much better way to handle your routes. It's so easy to implement, too. I'm just surprised I havent seen anything about it in tutorials or examples. It's always the same excuse. "I'm going to only have a single app.js for brevity."

Brevity is fine, but at least link to an example for the newcomers, or explain a decent separation of concerns. Don't promote bad practice. Node is meant to be _modular_.

If you don't want to take the effort to explain it, that's why this repository exists. I created it so you could link to it and say, "Hey, guy who's interested in Node.js and from a Rails background or is a beginner - you'll like this!"

## What are you on about?

So, what is this?

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

This `map()` function also designates some empty boilerplate CRUD HTTP operation maps for `index`, `new`, `create`, `show`, `edit`, `update` and `destroy`, respectively, so that writing out your controllers becomes an easy task.

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

## So what about route-specific middleware? How do you call that?

Quite simple actually. I just check the type of object associated with the route. If it's just a plain function, then the route
gets called and the app goes on it's way to any other route. But if the type is an array of functions, then it knows to call them in order.

Have a look at the console output of the `/login` route. Middleware gets called from the `home` controller:

```coffeescript
first_middleware = (req, res, next) ->
  console.log "First middleware making contact."
  do next

second_middleware = (req, res, next) ->
  console.log "Second middleware received contact. Phasing to route sequence."
  do next

exports.index = (req, res) ->
  res.send "Hello World from the Home Controller!"

exports.about = (req, res) ->
  res.send "About us - we're an awesome bunch of HTML bits."

exports.login = [
  first_middleware,
  second_middleware,
  (req, res) ->
    res.send 'This is a login and it uses middleware. Check the console to confirm it is being called.'
    console.log 'Final Route called.'
]
```

## Conclusion

Have a look at the source for `resource.coffee` and `resources.coffee` in the `boot` folder. It really _is_ that simple to set up if you want to keep your code a little bit more organized and not have loads of `app.<verb>` calls in your main application file. Remember, though, that this is a rather opinionated setup - there are no checks to make sure the files are in the right place or any checks for if the `routes` file is empty, but adding that in would be equally as trivial as setting this up in the first place. I hope you enjoyed finding out the solution to better organizing your routes as I did coding it. :smile:
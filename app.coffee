app = require('express')()

resources = require './boot/resources'

resources.load(app)

app.listen 5000, ->
  console.log 'Server started on port 5000.'
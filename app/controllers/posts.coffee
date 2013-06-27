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
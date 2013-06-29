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
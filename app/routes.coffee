###
#
#  Custom routes
#
###

routes = {

  '/': {
    controller: 'home'
  }

  'get /user': {
    controller: 'home'
    action: 'user'
  }

  'put /post': {
    controller: 'posts'
    action: 'update'
  }

}

module.exports = routes
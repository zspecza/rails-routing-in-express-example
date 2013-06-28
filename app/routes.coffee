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

  '/timmy': {
    controller: 'somethinghidden'
    action: 'timmy'
  }

}

module.exports = routes
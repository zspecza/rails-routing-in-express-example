###
#
#  Custom routes
#
###

routes = {

  '/': {
    controller: 'home'
  }

  '/about': {
    controller: 'home'
    action: 'about'
  }

  '/login': {
    controller: 'home'
    action: 'login'
  }

}

module.exports = routes
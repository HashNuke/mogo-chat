App.UserEditRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    controller.set "user", model.getProperties("firstName", "lastName", "email", "password", "role")

  model: ->
    @modelFor("user")

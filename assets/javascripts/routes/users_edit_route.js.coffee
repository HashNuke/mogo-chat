App.UserEditRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    controller.set "user", model.getProperties("firstName", "lastName", "domainId", "role", "username")
    controller.set "domains", @store.find("domain")

  model: ->
    @modelFor("user")

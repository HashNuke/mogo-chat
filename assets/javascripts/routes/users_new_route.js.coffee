App.UsersNewRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    controller.set "domains", @store.find("domain")

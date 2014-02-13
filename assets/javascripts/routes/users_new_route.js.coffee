App.UsersNewRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    controller.set("model", @store.createRecord("user", {role: "member"}))


  deactivate: ->
    @controller.get("model").rollback()

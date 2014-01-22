App.IndexRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    controller.set("room_user_states", @store.find("room_user_state"))
    @_super(controller, model)

  model: ()->
    @store.find("room")

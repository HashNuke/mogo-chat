App.ChatRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    @store.find("room_user_state")
    controller.set()
    @_super(controller, model)

  model: ()->
    @store.find("room")

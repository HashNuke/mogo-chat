App.RoomEditRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    controller.set "roomName", model.getProperties("name")
    @_super(controller, model)

  model: ->
    @modelFor("room")

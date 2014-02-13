App.RoomEditRoute = App.AuthenticatedRoute.extend
  model: ->
    @modelFor("room")

  deactivate: ->
    @controller.get("model").rollback()

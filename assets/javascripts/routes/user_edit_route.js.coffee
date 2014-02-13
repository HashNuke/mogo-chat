App.UserEditRoute = App.AuthenticatedRoute.extend
  model: ->
    @modelFor("user")

  deactivate: ->
    @controller.get("model").rollback()

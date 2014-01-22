App.IndexRoute = App.AuthenticatedRoute.extend

  model: ()->
    @store.find("room_user_state")

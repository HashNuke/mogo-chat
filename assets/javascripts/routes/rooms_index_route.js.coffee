App.RoomsIndexRoute = App.AuthenticatedRoute.extend
  model: (params)->
    @store.find("room")

App.UsersIndexRoute = App.AuthenticatedRoute.extend
  model: (params)->
    @store.find("user")

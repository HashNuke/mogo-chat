App.UserRoute = App.AuthenticatedRoute.extend
  model: (params)->
    if params.user_id
      @store.find("user", params.user_id)
    else
      {}

App.RoomRoute = App.AuthenticatedRoute.extend
  model: (params)->
    if params.room_id
      @store.find("room", params.room_id)
    else
      {}

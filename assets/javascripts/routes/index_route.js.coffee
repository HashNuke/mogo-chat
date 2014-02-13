App.IndexRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    activeState = null

    # Loop thru all room states
    #   find the first joined room to load
    #   start pollers for all joined rooms
    model.forEach (item)=>

      # This is to make sure the first active room is loaded
      if item.get("joined") == true
        activeState = item if !activeState?

        item.messagePoller = new App.MessagePoller()
        item.messagePoller.store = @store
        item.messagePoller.setRoom item.get("room")
        item.messagePoller.start()

        item.usersPoller = new App.UsersPoller()
        item.usersPoller.store = @store
        item.usersPoller.setRoom item.get("room")
        item.usersPoller.start()

    controller.set("activeState", activeState)
    @_super(controller, model)


  model: ->
    @store.find("room_user_state")

  deactivate: ->
    @controller.get("model").forEach (item)=>
      item.messagePoller.stop() if item.messagePoller
      item.usersPoller.stop() if item.usersPoller

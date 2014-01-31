App.IndexRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    stateData   = {}
    stateIds = []
    activeState = null

    # Loop thru all room states
    #   find the first joined room to load
    #   start pollers for all joined rooms
    model.forEach (item)=>
      stateId = item.get("id")
      stateIds.push(stateId)

      # This is to make sure the first active room is loaded
      if item.get("joined") == true
        activeState = item if !activeState?
        poller = new App.Poller()
        poller.store  = @store
        poller.setRoom item.get("room")
        poller.start(item.get("room").get("id"))
        stateData[stateId] = {"poller": poller}
      else
        stateData[stateId] = {}

    controller.set("stateIds", stateIds)
    controller.set("stateData", stateData)
    controller.set("activeState", activeState)
    @_super(controller, model)


  model: ->
    @store.find("room_user_state")

  deactivate: ->
    stateData = @controller.get("stateData")
    for stateId, state of stateData
      state.poller.stop() if state.poller

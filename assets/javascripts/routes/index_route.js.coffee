App.IndexRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    states   = []
    stateIds = []
    activeState = null

    model.forEach (item)->
      stateId = item.get("id")
      if !activeState? && item.get("joined") == true
        activeState = item
      states.push(stateId)
      states[stateId] = {}

    for stateId in stateIds
      console.log "k:", stateId, states[stateId]

    controller.set("stateIds", stateIds)
    controller.set("states", states)
    controller.set("activeState", activeState)
    @_super(controller, model)


  model: ->
    @store.find("room_user_state")

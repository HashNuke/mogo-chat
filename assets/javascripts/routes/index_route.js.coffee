App.IndexRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    states   = []
    stateIds = []
    activeStateId = null

    model.forEach (item)->
      stateId = item.get("id")
      unless activeStateId? && item.get("joined") == true
        activeStateId = item.get("id")
      states.push(stateId)
      states[stateId] = {}

    for stateId in stateIds:
      console.log "k:", stateId, states[stateId]

    controller.set("stateIds", stateIds)
    controller.set("states", states)
    controller.set("activeStateId", activeStateId)
    @_super(controller, model)


  model: -> @store.find("room_user_state")


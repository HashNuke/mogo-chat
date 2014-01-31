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


App.Poller = Em.Object.extend
  start: ()->
    @started = true
    @messages = []
    @beforeMessageId = null
    @timer = setInterval @onPoll.bind(@), 3000

  setRoom: (room)->
    @room = room
    @roomId = @room.get("id")

  stop: ->
    return true if !@started
    clearInterval(@timer)
    @started = false

  onPoll: ->
    if @afterMessageId
      url = "/api/messages/#{@roomId}?after=#{@afterMessageId}"
    else
      url = "/api/messages/#{@roomId}"

    $.getJSON url, (response)=>
      Em.$.each response.messages, (index, message)=>
        if (! @store.recordIsLoaded(App.Message, message.id))
          messageParams =
            id: message.id
            type: message.type
            body: message.body
          messageObj = @store.createRecord("message", messageParams)
          messageObj.set("room", @room)
          @afterMessageId = message.id

          if(@store.recordIsLoaded("user", message.user.id))
            @store.find("user", message.user.id).then (user)=>
              messageObj.set("user", user)
              #TODO push or shift depending on the query
              @room.get("messages").pushObject(messageObj)
          else
            userParams =
              id: message.user.id
              firstName: message.user.first_name
              lastName: message.user.last_name
              role: message.user.role
            user = @store.createRecord("user", userParams)
            messageObj.set("user", user)
            #TODO push or shift depending on the query
            @room.get("messages").pushObject(messageObj)

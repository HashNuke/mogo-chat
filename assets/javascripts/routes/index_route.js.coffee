App.IndexRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    stateData   = []
    stateIds = []
    activeState = null

    # Loop thru all room states
    #   find the first joined room to load
    #   start pollers for all joined rooms
    model.forEach (item)=>
      stateId = item.get("id")
      stateIds.push(stateId)
      console.log stateId

      # This is to make sure the first active room is loaded
      if item.get("joined") == true
        activeState = item if !activeState?
        poller = new App.Poller()
        poller.store  = @store
        poller.roomId = item.get("room").get("id")
        poller.start(item.get("room").get("id"))
        stateData[stateId] = {"poller": poller}
      else
        stateData[stateId] = {}

    for stateId in stateIds
      console.log "stateId: #{stateId}"

    controller.set("stateIds", stateIds)
    controller.set("stateData", stateData)
    controller.set("activeState", activeState)
    @_super(controller, model)


  model: ->
    @store.find("room_user_state")

  deactivate: ->
    states = controller.get("states")
    console.log states


App.Poller = Em.Object.extend
  start: ()->
    @started = true
    @messages = []
    @beforeMessageId = null
    @timer = setInterval @onPoll.bind(@), 3000

  stop: ->
    clearInterval(@timer)
    @started = false

  onPoll: ->
    console.log("polling now #{@roomId}")
    if @afterMessageId
      console.log "after #{@afterMessageId}"
      url = "/api/messages/#{@roomId}?after=#{@afterMessageId}"
    else
      url = "/api/messages/#{@roomId}"

    $.getJSON url, (response)=>
      Em.$.each response.messages, (index, message)=>
        if (! @store.recordIsLoaded(App.Message, message.id))
          console.log message
          @afterMessageId = message.id



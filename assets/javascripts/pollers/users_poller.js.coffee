App.UsersPoller = Em.Object.extend

  start: ()->
    @started = true
    @fetchUsers() && @timer = setInterval(@fetchUsers.bind(@), 5000)

  setRoomState: (roomState)->
    @roomState = roomState

  stop: ->
    return true if !@started
    clearInterval(@timer)
    @started = false


  fetchUsers: ->
    $.getJSON "/api/rooms/#{@roomState.get("room.id")}/users", (response)=>
      return true if !response.users
      #TODO normalizePayload of serializer doesn't seem to do much
      @roomState.set("room.users", [])
      @roomState.trigger "addUsers", response.users

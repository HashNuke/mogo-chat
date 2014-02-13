App.UsersPoller = Em.Object.extend

  start: ()->
    @started = true
    @fetchUsers() && @timer = setInterval(@fetchUsers.bind(@), 5000)

  setRoom: (room)->
    @room = room
    @roomId = @room.get("id")

  stop: ->
    return true if !@started
    clearInterval(@timer)
    @started = false


  onEachUser: (index, userAttributes)->
    if @store.recordIsLoaded("user", userAttributes.id)
      user = @store.getById("user", userAttributes.id)
    else
      user = @store.push("user",
        id: userAttributes.id
        firstName: userAttributes.first_name
        lastName: userAttributes.last_name
        role: userAttributes.role
        color: App.paintBox.getColor()
      )
    @room.get("users").pushObject(user)


  fetchUsers: ->
    $.getJSON "/api/rooms/#{@roomId}/users", (response)=>
      return true if !response.users
      #TODO normalizePayload of serializer doesn't seem to do much
      @room.set("users", [])
      Em.$.each response.users, @onEachUser.bind(@)

App.User = DS.Model.extend
  firstName: DS.attr("string")
  lastName:  DS.attr("string")
  email:  DS.attr("string")
  role:   DS.attr("string")
  password: DS.attr("string")


App.CurrentUser = App.User.extend({})


App.Room = DS.Model.extend
  name: DS.attr("string")
  roomUserState: DS.belongsTo("room_user_state")
  messages: DS.hasMany("message")
  users: DS.hasMany("user")
  # historyAvailable: DS.attr("virtual", {defaultValue: true})


App.RoomUserState = DS.Model.extend
  userId: DS.attr("number")
  joined:  DS.attr("boolean")
  room:  DS.belongsTo("room")
  lastPingedAt: DS.attr("date")


#TODO move this elsewhere
App.RoomUserStateSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    room: {embedded: "load"}
  }
})



App.Message = DS.Model.extend
  body: DS.attr("string")
  type: DS.attr("string")
  createdAt: DS.attr("string")
  user: DS.belongsTo("user")
  room: DS.belongsTo("room")

App.MessageSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    user: {embedded: "load"}
  }
})


App.MessagePoller = Em.Object.extend
  start: ()->
    @started = true
    @messages = []
    @beforeMessageId = null
    @fetchMessages() && @timer = setInterval(@fetchMessages.bind(@), 3000)

  setRoom: (room)->
    @room = room
    @roomId = @room.get("id")

  stop: ->
    return true if !@started
    clearInterval(@timer)
    @started = false


  onEachMessage: (index, message)->
    return true if (@store.recordIsLoaded("message", message.id))
    messageParams =
      id: message.id
      type: message.type
      body: message.body
      createdAt: message.created_at

    messageObj = @store.createRecord("message", messageParams)
    messageObj.set("room", @room)
    @afterMessageId = message.id

    if(@store.recordIsLoaded("user", message.user.id))
      successCallback = (user)=>
        messageObj.set("user", user)

      @store.find("user", message.user.id).then successCallback
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


  fetchMessages: ->
    if @afterMessageId
      url = "/api/messages/#{@roomId}?after=#{@afterMessageId}"
    else
      url = "/api/messages/#{@roomId}"

    $.getJSON url, (response)=>
      Em.$.each response.messages, @onEachMessage.bind(@)


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
      @store.find("user", userAttributes.id).then (user)=>
        @room.get("users").pushObject(user)
    else
      user = @store.createRecord("user",
        id: userAttributes.id
        firstName: userAttributes.first_name
        lastName: userAttributes.last_name
        role: userAttributes.role
      )
      @room.get("users").pushObject(user)

  fetchUsers: ->
    $.getJSON "/api/rooms/#{@roomId}/users", (response)=>
      return true if !response.users
      #TODO normalizePayload of serializer doesn't seem to do much
      @room.get("users").clear()
      Em.$.each response.users, @onEachUser.bind(@)

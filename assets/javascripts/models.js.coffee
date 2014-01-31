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
  user: DS.belongsTo("user")
  room: DS.belongsTo("room")
  createdAt: DS.attr("string")

App.MessageSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    user: {embedded: "load"}
  }
})


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
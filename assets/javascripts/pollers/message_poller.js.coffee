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
        color: App.paintBox.getColor()

      user = @store.createRecord("user", userParams)
      messageObj.set("user", user)
    #TODO push or shift depending on the query
    @room.get("messages").pushObject(messageObj)


  fetchMessages: ->
    if @afterMessageId
      url = "/api/messages/#{@roomId}?after=#{@afterMessageId}"
    else
      url = "/api/messages/#{@roomId}"

    getJsonCallback = (response)=>
      if (response.messages.length == 20 || response.messages.length == 0) && @room.get("messages.length") == 20
        @room.set("isHistoryAvailable", true)
      else
        @room.set("isHistoryAvailable", false)
      Em.$.each response.messages, @onEachMessage.bind(@)

    $.getJSON url, getJsonCallback.bind(@)

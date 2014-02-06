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


  onEachMessage: (index, messageAttrs)->
    if (@store.recordIsLoaded("message", messageAttrs.id))
      @store.find("message", messageAttrs.id).then (message)=>
        @room.get("messages").pushObject(message)
      return

    message = @store.createRecord("message", {
      id: messageAttrs.id,
      type: messageAttrs.type,
      body: messageAttrs.body,
      createdAt: messageAttrs.created_at
    })

    message.set("room", @room)
    @afterMessageId = messageAttrs.id

    if(@store.recordIsLoaded("user", messageAttrs.user.id))
      successCallback = (user)=>
        message.set("user", user)
      @store.find("user", messageAttrs.user.id).then successCallback
    else
      userParams =
        id: messageAttrs.user.id
        firstName: messageAttrs.user.first_name
        lastName: messageAttrs.user.last_name
        role: messageAttrs.user.role
        color: App.paintBox.getColor()

      user = @store.createRecord("user", userParams)
      messageObj.set("user", user)
    #TODO push or shift depending on the query
    @room.get("messages").pushObject(message)


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

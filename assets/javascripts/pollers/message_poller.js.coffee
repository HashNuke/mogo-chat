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


  onEachMessage: (before = false)->
    if before
      addAction = "unshiftObject"
    else
      addAction = "pushObject"

    (index, messageAttrs)=>
      @afterMessageId = messageAttrs.id
      if @store.recordIsLoaded("message", messageAttrs.id)
        message = @store.getById("message", messageAttrs.id)
        if !@room.get("messages").contains(message)
          @room.get("messages")[addAction](message)
        return

      message = @store.createRecord("message", {
        id: messageAttrs.id,
        type: messageAttrs.type,
        body: messageAttrs.body,
        createdAt: messageAttrs.created_at
      })

      message.set("room", @room)

      if @store.recordIsLoaded("user", messageAttrs.user.id)
        user = @store.getById("user", messageAttrs.user.id)
      else
        userParams =
          id: messageAttrs.user.id
          firstName: messageAttrs.user.first_name
          lastName: messageAttrs.user.last_name
          role: messageAttrs.user.role
          color: App.paintBox.getColor()
        user = @store.createRecord("user", userParams)

      message.set("user", user)
      @room.get("messages")[addAction](message)
      console.log "#{addAction}: #{message.get("id")}, #{@room.get("messages").content[0].get("id")}"
      if @room.get("messages.length") == 21 && addAction == "pushObject"
        @room.get("messages").shiftObject()


  fetchMessages: (before = false)->
    url = "/api/messages/#{@roomId}"
    if before
      url = "#{url}?before=#{before}"
    else if @afterMessageId
      url = "#{url}?after=#{@afterMessageId}"

    getJsonCallback = (response)=>
      if (response.messages.length == 20 || response.messages.length == 0) && @room.get("messages.length") >= 20
        @room.set("isHistoryAvailable", true)
      else
        @room.set("isHistoryAvailable", false)
      console.log @room.get("messages")
      Em.$.each response.messages, @onEachMessage(before).bind(@)

    $.getJSON url, getJsonCallback.bind(@)

App.MessagePoller = Em.Object.extend
  start: ()->
    @started = true
    @messages = []
    @beforeMessageId = null
    @fetchMessages() && @timer = setInterval(@fetchMessages.bind(@), 2500)

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
      if @route.store.recordIsLoaded("message", messageAttrs.id)
        message = @route.store.getById("message", messageAttrs.id)
        if !@room.get("messages").contains(message)
          @room.get("messages")[addAction](message)
        return

      message = @route.store.push("message", {
        id: messageAttrs.id,
        type: messageAttrs.type,
        body: messageAttrs.body,
        createdAt: messageAttrs.created_at
      })
      message.set("room", @room)

      if @route.store.recordIsLoaded("user", messageAttrs.user.id)
        user = @route.store.getById("user", messageAttrs.user.id)
      else
        userParams =
          id: messageAttrs.user.id
          name: messageAttrs.user.name
          role: messageAttrs.user.role
          color: App.paintBox.getColor()
        user = @route.store.push("user", userParams)

      message.set("user", user)
      @room.get("messages")[addAction](message)

      if message.get("body").match(@route.controller.get("currentUser").get("name")) && addAction == "pushObject" && @afterMessageId
        console.log "matched #{@afterMessageId}"
        $audio = $("audio")[0]
        $audio.load()
        $audio.play()

      if @room.get("messages.length") == (MogoChat.config.messagesPerLoad + 1) && addAction == "pushObject"
        @room.get("messages").shiftObject()


  fetchMessages: (before = false)->
    url = "/api/messages/#{@roomId}"
    if before
      url = "#{url}?before=#{before}"
    else if @afterMessageId
      url = "#{url}?after=#{@afterMessageId}"

    getJsonCallback = (response)=>
      if response.messages.length >= MogoChat.config.messagesPerLoad && (before != false || !@afterMessageId)
        @room.set("isHistoryAvailable", true)
      else if before != false && response.messages.length < MogoChat.config.messagesPerLoad
        @room.set("isHistoryAvailable", false)

      Em.$.each response.messages, @onEachMessage(before).bind(@)
      if response.messages.length > 0 && !before
        @afterMessageId = response.messages[response.messages.length - 1].id

    $.getJSON url, getJsonCallback.bind(@)

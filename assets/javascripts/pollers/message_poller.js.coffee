App.MessagePoller = Em.Object.extend
  start: ()->
    @started = true
    @fetchMessages() && @timer = setInterval(@fetchMessages.bind(@), 2500)

  setRoomState: (roomState)->
    @roomState = roomState

  stop: ->
    return true if !@started
    clearInterval(@timer)
    @started = false


  fetchMessages: (before = false)->
    url = "/api/messages/#{@roomState.get("room.id")}"
    if before
      url = "#{url}?before=#{before}"
    else if @roomState.get("afterMessageId")
      url = "#{url}?after=#{@roomState.get("afterMessageId")}"

    getJsonCallback = (response)=>
      if response.messages.length >= MogoChat.config.messagesPerLoad && (before != false || !@roomState.get("afterMessageId"))
        @roomState.set("room.isHistoryAvailable", true)
      else if before != false && response.messages.length < MogoChat.config.messagesPerLoad
        @roomState.set("room.isHistoryAvailable", false)

      @roomState.trigger("addMessages", {before: before, messages: response.messages})

    $.getJSON url, getJsonCallback.bind(@)

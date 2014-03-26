App.IndexController = Ember.ArrayController.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")
  isLeftMenuOpen: Ember.computed.alias("controllers.application.isLeftMenuOpen")
  isRightMenuOpen: Ember.computed.alias("controllers.application.isRightMenuOpen")

  itemController: "RoomUserStateItem"


  detectTypeAndFormatBody: (body)->
    if body.match("\n")
      {type: "paste", body: body}
    else if matches = (/^\/me (.*)/g).exec(body)
      {type: "me", body: matches[1]}
    else
      {type: "text", body: body}


  actions:
    loadHistory: ->
      activeState = @get("activeState")
      room = activeState.get("room")
      if room.get("messages")[0]
        beforeId = room.get("messages")[0].get("id")
      else
        beforeId = true

      activeState.messagePoller.fetchMessages(beforeId)


    postMessage: (msgTxt)->
      escapedBody = $('<div/>').text(msgTxt).html()
      msgTxt = msgTxt.replace(/\s*$/g, "")
      room = @get("activeState").get("room")
      currentUser = @get("currentUser")
      formatted = @detectTypeAndFormatBody(msgTxt)
      messageParams =
        room: room
        body: msgTxt
        type: formatted.type
        createdAt: new Date()
        user: currentUser

      msg = @store.createRecord("message", messageParams)

      if room.get("messages.length") == (MogoChat.config.messagesPerLoad + 1)
        room.get("messages").shiftObject()

      successCallback = =>
        room.get("messages").pushObject(msg)
        # Note, this can't be set before save(), because createRecord empties this
        if formatted.type != "paste"
          msg.set "formattedBody", App.plugins.processMessageBody(escapedBody, formatted.type)
      errorCallback   = =>
        msg.set("errorPosting", true)
        room.get("messages").pushObject(msg)
        if formatted.type != "paste"
          msg.set "formattedBody", App.plugins.processMessageBody(escapedBody, formatted.type)
      msg.save().then(successCallback, errorCallback)

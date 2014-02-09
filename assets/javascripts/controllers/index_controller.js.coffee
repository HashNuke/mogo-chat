App.IndexController = Ember.ArrayController.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")
  isLeftMenuOpen: Ember.computed.alias("controllers.application.isLeftMenuOpen")
  isRightMenuOpen: Ember.computed.alias("controllers.application.isRightMenuOpen")

  itemController: "RoomUserStateItem"


  detectMessageType: (msgTxt)->
    if msgTxt.match("\n")
      "paste"
    else
      "text"


  actions:
    loadHistory: ->
      activeState = @get("activeState")
      room = activeState.get("room")
      beforeId = room.get("messages")[0].get("id")
      activeState.messagePoller.fetchMessages(beforeId)


    postMessage: (msgTxt)->
      msgTxt = msgTxt.trim()
      room = @get("activeState").get("room")
      currentUser = @get("currentUser")
      messageParams =
        room: room
        body: msgTxt
        type: @detectMessageType(msgTxt)
        createdAt: new Date()
        user: currentUser

      msg = @store.createRecord("message", messageParams)
      if room.get("messages.length") == 21
        room.get("messages").shiftObject()
      successCallback = ->
        console.log "message has been posted"
      errorCallback   = ->
        console.log "error posting message"
      msg.save().then(successCallback, errorCallback)


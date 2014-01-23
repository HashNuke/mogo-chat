App.IndexController = Ember.ArrayController.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")
  itemController: "RoomUserStateItem"


  detectMessageType: (msgTxt)->
    if msgTxt.match("\n")
      "paste"
    else
      "text"


  actions:
    postMessage: (msgTxt)->
      msgTxt = msgTxt.trim()
      room = @get("activeState").get("room")
      console.log "To room #{room.get("name")}:", msgTxt
      currentUser = @get("currentUser")
      messageParams =
        roomId: room.get("id")
        body: msgTxt
        type: @detectMessageType(msgTxt)
        createdAt: new Date()
        user: currentUser

      console.log messageParams
      msg = @store.createRecord("message", messageParams)
      successCallback = ->
        console.log "message has been posted"
      errorCallback   = ->
        console.log "error posting message"
      msg.save().then(successCallback, errorCallback)

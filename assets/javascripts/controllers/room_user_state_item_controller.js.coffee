App.RoomUserStateItemController = Em.ObjectController.extend
  needs: ["application", "index"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")

  actions:

    leaveRoom: ->
      roomItemState = @get("model")
      roomItemState.messagePoller.stop()
      roomItemState.usersPoller.stop()
      roomItemState.set("joined", false)
      roomItemState.save()
      @get("controllers.index").set("activeState", null)


    joinOrOpen: ->
      roomItemState = @get("model")
      if roomItemState.get("joined") == false
        roomItemState.set("joined", true)

        roomItemState.messagePoller = new App.MessagePoller()
        roomItemState.messagePoller.setRoomState roomItemState
        roomItemState.messagePoller.start()

        roomItemState.usersPoller = new App.UsersPoller()
        roomItemState.usersPoller.setRoomState roomItemState
        roomItemState.usersPoller.start()

        successCallback = =>
          console.log("saved")
        errorCallback = =>
          console.log("error whatever...")
        roomItemState.save().then(successCallback, errorCallback)

      @get("controllers.index").set("activeState", roomItemState)
      #TODO load the channel

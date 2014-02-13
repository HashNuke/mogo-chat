App.RoomUserStateItemController = Em.ObjectController.extend
  needs: ["application", "index"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")

  actions:
    join: ->
      room_item_state = @get("model")
      if room_item_state.get("joined") == false
        room_item_state.set("joined", true)

        #TODO this can be abstracted into a function on the room state
        room_item_state.messagePoller = new App.MessagePoller()
        room_item_state.messagePoller.store = @store
        room_item_state.messagePoller.setRoom room_item_state.get("room")
        room_item_state.messagePoller.start()

        room_item_state.usersPoller = new App.UsersPoller()
        room_item_state.usersPoller.store = @store
        room_item_state.usersPoller.setRoom room_item_state.get("room")
        room_item_state.usersPoller.start()


        successCallback = =>
          console.log("saved")
        errorCallback = =>
          console.log("error whatever...")
        room_item_state.save().then(successCallback, errorCallback)

      @get("controllers.index").set("activeState", room_item_state)
      #TODO load the channel

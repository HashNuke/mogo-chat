App.RoomUserStateItemController = Em.ObjectController.extend
  needs: ["application", "index"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")

  actions:
    join: ->
      room_item_state = @get("model")
      if room_item_state.get("joined") == false
        room_item_state.set("joined", true)

        successCallback = =>
          console.log("saved")
        errorCallback = =>
          console.log("error whatever...")
        room_item_state.save().then(successCallback, errorCallback)

      @get("controllers.index").set("activeState", room_item_state)
      #TODO load the channel


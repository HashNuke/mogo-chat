App.RoomUserStateItemController = Em.ObjectController.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")

  actions:
    join: ->
      console.log("hi", arguments)
      room_item_state = @get("model")
      console.log room_item_state.get("joined")
      room_item_state.set("joined", true)
      console.log room_item_state.get("joined")

      # successCallback  = =>
      #   console.log("deleted")
      # errorCallback = =>
      #   console.log("error whatever...")
      # # user.save().then(successCallback, errorCallback)

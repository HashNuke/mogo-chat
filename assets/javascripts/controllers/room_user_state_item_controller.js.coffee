App.RoomUserStateItemController = Em.ObjectController.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")

  actions:
    join: ->
      room_item_state = @get("model")
      room_item_state.set("joined", true)

      successCallback  = =>
        console.log("saved")
      errorCallback = =>
        console.log("error whatever...")
      room_item_state.save().then(successCallback, errorCallback)

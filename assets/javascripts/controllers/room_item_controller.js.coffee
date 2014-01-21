App.RoomItemController = Em.ObjectController.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")

  actions:
    remove: ->
      room = @get("model")
      room.deleteRecord()
      successCallback  = =>
        console.log("deleted")
      errorCallback = =>
        console.log("error deleting room...")
      room.save().then(successCallback, errorCallback)

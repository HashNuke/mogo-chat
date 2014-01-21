App.RoomsNewController = Em.Controller.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")

  actions:
    save: ->
      roomAttributes = @getProperties(["roomName"])

      room = @store.createRecord("room", roomAttributes)
      successCallback = =>
        @transitionToRoute("rooms.index")
      errorCallback = => console.log("error saving room")
      room.save().then(successCallback, errorCallback)

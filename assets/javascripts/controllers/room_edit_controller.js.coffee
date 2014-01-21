App.RoomEditController = Em.Controller.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")

  actions:
    save: ->
      roomAttributes = @getProperties(["name"])
      room = @get("model").setProperties(userAttributes)
      successCallback = =>
        @transitionToRoute("rooms.index")
      errorCallback = => console.log("error saving room")
      room.save().then(successCallback, errorCallback)

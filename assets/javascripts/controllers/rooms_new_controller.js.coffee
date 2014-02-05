App.RoomsNewController = Em.Controller.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")
  isLeftMenuOpen: Ember.computed.alias("controllers.application.isLeftMenuOpen")
  isRightMenuOpen: Ember.computed.alias("controllers.application.isRightMenuOpen")

  actions:
    save: ->
      roomAttributes = {name: @get("roomName")}
      room = @store.createRecord("room", roomAttributes)
      successCallback = =>
        @transitionToRoute("rooms.index")
      errorCallback = => console.log("error saving room")
      room.save().then(successCallback, errorCallback)

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

      errorCallback = (response) =>
        if response.errors
          @set("errors", response.errors)
        else
          @set("errorMsg", "Oops ~! something went wrong")

      room.save().then(successCallback, errorCallback)

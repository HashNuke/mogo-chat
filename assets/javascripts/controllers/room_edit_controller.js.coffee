App.RoomEditController = Em.Controller.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")
  isLeftMenuOpen: Ember.computed.alias("controllers.application.isLeftMenuOpen")
  isRightMenuOpen: Ember.computed.alias("controllers.application.isRightMenuOpen")

  actions:
    save: ->
      successCallback = =>
        @transitionToRoute("rooms.index")

      errorCallback = (response) =>
        console.log response
        if response.errors
          @set("errors", response.errors)
        else
          @set("errorMsg", "Oops ~! something went wrong")
      @get("model").save().then(successCallback, errorCallback)

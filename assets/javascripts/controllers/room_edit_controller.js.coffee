App.RoomEditController = Em.Controller.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")
  isLeftMenuOpen: Ember.computed.alias("controllers.application.isLeftMenuOpen")
  isRightMenuOpen: Ember.computed.alias("controllers.application.isRightMenuOpen")

  actions:
    save: ->
      successCallback = =>
        @transitionToRoute("rooms.index")
      errorCallback = => console.log("error saving room")
      @get("model").save().then(successCallback, errorCallback)

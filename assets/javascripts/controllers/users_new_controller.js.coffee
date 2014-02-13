App.UsersNewController = Em.Controller.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")
  isLeftMenuOpen: Ember.computed.alias("controllers.application.isLeftMenuOpen")
  isRightMenuOpen: Ember.computed.alias("controllers.application.isRightMenuOpen")

  validRoles: ["member", "admin"]

  actions:
    save: ->
      @get("model").set("color", App.paintBox.getColor())

      successCallback = =>
        @transitionToRoute("users.index")
      errorCallback = => console.log("error saving user")
      @get("model").save().then(successCallback, errorCallback)

App.UsersNewController = Em.Controller.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")
  isLeftMenuOpen: Ember.computed.alias("controllers.application.isLeftMenuOpen")
  isRightMenuOpen: Ember.computed.alias("controllers.application.isRightMenuOpen")
  paintBox: Ember.computed.alias("controllers.application.paintBox")

  validRoles: ["member", "admin"]

  actions:
    save: ->
      userAttributes = @getProperties(["firstName", "lastName", "role", "password", "email"])
      userAttributes["color"] = @get("paintBox").getColor()

      user = @store.createRecord("user", userAttributes)
      successCallback = =>
        @transitionToRoute("users.index")
      errorCallback = => console.log("error saving user")
      user.save().then(successCallback, errorCallback)

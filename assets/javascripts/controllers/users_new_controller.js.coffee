App.UsersNewController = Em.Controller.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")
  isLeftMenuOpen: Ember.computed.alias("controllers.application.isLeftMenuOpen")
  isRightMenuOpen: Ember.computed.alias("controllers.application.isRightMenuOpen")

  validRoles: ["member", "admin"]

  actions:
    save: ->
      userAttributes = @getProperties(["firstName", "lastName", "role", "password", "email"])

      user = @store.createRecord("user", userAttributes)
      successCallback = =>
        @transitionToRoute("users.index")
      errorCallback = => console.log("error saving user")
      user.save().then(successCallback, errorCallback)

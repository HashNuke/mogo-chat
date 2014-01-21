App.UserEditController = Em.Controller.extend
  needs: ["application"]
  validRoles: ["member", "admin"]

  actions:
    save: ->
      userAttributes = @getProperties(["firstName", "lastName", "role", "password", "email"])
      user = @get("model").setProperties(userAttributes)
      successCallback = =>
        @transitionToRoute("users.index")
      errorCallback = => console.log("error saving user")
      user.save().then(successCallback, errorCallback)

App.UserEditController = Em.Controller.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")
  isLeftMenuOpen: Ember.computed.alias("controllers.application.isLeftMenuOpen")
  isRightMenuOpen: Ember.computed.alias("controllers.application.isRightMenuOpen")

  validRoles: ["member", "admin"]

  actions:
    save: ->
      successCallback = =>
        @transitionToRoute("users.index")

      errorCallback = (response) =>
        if response.errors
          @set("errors", response.errors)
        else
          @set("errorMsg", "Oops ~! something went wrong")
      @get("model").save().then(successCallback, errorCallback)

App.LoginController = Em.Controller.extend
  needs: ["application"]

  actions:
    login: ->
      data = @getProperties("email", "password")

      errorCallback = (response) =>
        if response.responseJSON
          @set("error", response.responseJSON.error)
        else
          @set("error", "Oops ~! something went wrong")

      successCallback = (response)=>
        userAttributes = {
          id: response.user.id,
          name: response.user.name,
          role: response.user.role,
          color: App.paintBox.getColor()
        }

        if @store.recordIsLoaded("user", userAttributes.id)
          @store.find("user", userAttributes.id).then (user)=>
            @set("controllers.application.currentUser", user)
            @transitionToRoute("index")
        else
          user = @store.push("user", userAttributes)
          @set("controllers.application.currentUser", user)
          @transitionToRoute("index")
      Em.$.post("/api/sessions", data).then successCallback, errorCallback

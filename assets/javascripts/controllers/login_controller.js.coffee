App.LoginController = Em.Controller.extend
  needs: ["application"]
  email: "admin@example.com"
  password: "password"
  paintBox: Ember.computed.alias("controllers.application.paintBox")

  actions:
    login: ->
      data = @getProperties("email", "password")
      Em.$.post("/api/sessions", data).then (response)=>
        if response.error
          console.log "error", response
        else
          userAttributes = {
            id: response.user.id,
            firstName: response.user.first_name,
            lastName: response.user.last_name,
            role: response.user.role,
            color: @get("paintBox").getColor()
          }

          if @store.recordIsLoaded("user", userAttributes.id)
            @store.find("user", userAttributes.id).then (user)=>
              @set("controllers.application.currentUser", user)
              @transitionToRoute("index")
          else
            user = @store.createRecord("user", userAttributes)
            @set("controllers.application.currentUser", user)
            @transitionToRoute("index")

App.LoginController = Em.Controller.extend
  needs: ["application"]
  email: "admin@example.com"
  password: "password"

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
            role: response.user.role
          }
          user = @store.createRecord("current_user", userAttributes)
          @set("controllers.application.currentUser", user)
          @transitionToRoute("index")

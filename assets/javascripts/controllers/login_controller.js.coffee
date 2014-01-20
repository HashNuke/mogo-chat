App.LoginController = Em.Controller.extend
  needs: ["application"]
  email: "admin@example.com"
  password: "password"

  actions:
    login: ->
      data = @getProperties('email', 'password')
      Em.$.post("/api/sessions", data).then (response)=>
        if response.error
          console.log "error", response
        else
          user = @store.createRecord('user', response.user)
          @set("controllers.application.currentUser", user)
          @transitionToRoute('index')

App.AuthenticatedRoute = Em.Route.extend
  beforeModel: (transition)->
    applicationController = @controllerFor("application")
    if applicationController.get("currentUser")
      return true

    Em.$.getJSON("/api/sessions").then (response)=>
      if response.user
        userAttributes = {
          id: response.user.id,
          firstName: response.user.first_name,
          lastName: response.user.last_name,
          role: response.user.role
        }
        user = @store.createRecord("current_user", userAttributes)
        @controllerFor("application").set("currentUser", user)
      else
        @redirectToLogin(transition)

  # Redirect to the login page and store the current transition so we can
  # run it again after login
  redirectToLogin: (transition)->
    loginController = @controllerFor("login")
    # loginController.set("attemptedTransition", transition)
    @transitionTo("login")

  #TODO not sure why this is here
  actions:
    error: (reason, transition)->
      console.log "ERROR: moving to login", error
      this.redirectToLogin(transition)

App.LogoutRoute = App.AuthenticatedRoute.extend
  setupController: (model, controller)->
    Em.$.ajax(url:  "/api/sessions", type: "DELETE")
      .then (result)=>
        return if !result.ok
        @controllerFor("application").get("currentUser").deleteRecord()
        @controllerFor("application").set("currentUser", false)
        @transitionTo("login")

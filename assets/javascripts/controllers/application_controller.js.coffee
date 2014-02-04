App.ApplicationController = Em.Controller.extend
  currentUser: false
  isMenuLeftOpen: false

  actions:
    logout: ->
      Em.$.ajax(url:  "/api/sessions", type: "DELETE")
        .then (result)=>
          return if !result.ok
          @get("currentUser").deleteRecord()
          @set("currentUser", false)
          @transitionToRoute("login")


App.ApplicationRoute = Em.Route.extend
  actions:
    toggleLeftMenu: ->
      console.log "clicked to toggle menu; next debug"
      if @controllerFor("application").get("isLeftMenuOpen") == false
        @controllerFor("application").set("isLeftMenuOpen", true)
      else
        @controllerFor("application").set("isLeftMenuOpen", false)

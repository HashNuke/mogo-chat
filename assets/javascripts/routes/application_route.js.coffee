App.ApplicationRoute = Em.Route.extend
  actions:
    toggleLeftMenu: ->
      console.log "clicked to toggle menu; next debug"
      if @controllerFor("application").get("isLeftMenuOpen") == false
        @controllerFor("application").set("isLeftMenuOpen", true)
      else
        @controllerFor("application").set("isLeftMenuOpen", false)

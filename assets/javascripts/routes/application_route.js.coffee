App.ApplicationRoute = Em.Route.extend
  actions:
    toggleLeftMenu: ->
      @controllerFor("application").set(
        "isLeftMenuOpen",
        !@controllerFor("application").get("isLeftMenuOpen")
      )

    toggleRightMenu: ->
      @controllerFor("application").set(
        "isRightMenuOpen",
        !@controllerFor("application").get("isRightMenuOpen")
      )

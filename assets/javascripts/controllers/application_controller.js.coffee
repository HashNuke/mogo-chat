App.ApplicationController = Em.Controller.extend
  currentUser: false
  isLeftMenuOpen: false
  isRightMenuOpen: false

  actions:
    logout: ->
      Em.$.ajax(url:  "/api/sessions", type: "DELETE")
        .then (result)=>
          return if !result.ok
          @get("currentUser").deleteRecord()
          @set("currentUser", false)
          @transitionToRoute("login")

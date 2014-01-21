App.UserItemController = Em.ObjectController.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")

  isCurrentUser: (->
    @get("currentUser").id == @get("model").id
  ).property("currentUser")

  actions:
    remove: ->
      user = @get("model")
      user.deleteRecord()
      successCallback  = =>
        console.log("deleted")
      errorCallback = =>
        console.log("error whatever...")
      user.save().then(successCallback, errorCallback)

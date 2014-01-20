App.UserItemController = Em.ObjectController.extend
  actions:
    remove: ->
      user = @get("model").deleteRecord()
      successCallback  = =>
        console.log("deleted")
      errorCallback = =>
        console.log("error whatever...")
      user.save().then(successCallback, errorCallback)

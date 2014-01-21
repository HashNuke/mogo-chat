App.RoomsIndexController = Em.ArrayController.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")
  itemController: "RoomItem"

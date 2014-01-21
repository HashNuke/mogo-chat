App.UsersIndexController = Em.ArrayController.extend
  needs: ["application"]
  currentUser: Ember.computed.alias("controllers.application.currentUser")
  itemController: "UserItem"
  title: "Users"

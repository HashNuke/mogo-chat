App.UsersIndexController = Em.ArrayController.extend
  needs: ["application"]
  itemController: "UserItem"
  title: "Users"

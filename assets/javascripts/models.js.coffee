App.Channel = DS.Model.extend
  channel: DS.attr("string")
  networkId: DS.attr("string")

App.Activity = DS.Model.extend
  body: DS.attr("string")
  type: DS.attr("string")

App.ActivityType = DS.Model.extend
  name: DS.attr("string")

App.User = DS.Model.extend
  username: DS.attr("string")

App.CurrentUser = App.User.extend({})

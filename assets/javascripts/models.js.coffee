App.User = DS.Model.extend
  firstName: DS.attr("string")
  lastName: DS.attr("string")

App.CurrentUser = App.User.extend({})

App.Channel = DS.Model.extend
  channel: DS.attr("string")

App.Activity = DS.Model.extend
  body: DS.attr("string")
  type: DS.attr("string")
  channelId: DS.attr("string")
  userId: DS.attr("string")

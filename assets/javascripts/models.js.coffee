App.User = DS.Model.extend
  firstName: DS.attr("string")
  lastName:  DS.attr("string")
  email:  DS.attr("string")
  role:  DS.attr("string")

App.CurrentUser = App.User.extend({})

App.Room = DS.Model.extend
  name: DS.attr("string")

App.Message = DS.Model.extend
  body:   DS.attr("string")
  type:   DS.attr("string")
  roomId: DS.attr("string")
  userId: DS.attr("string")

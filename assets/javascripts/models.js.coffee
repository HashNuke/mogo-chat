App.User = DS.Model.extend
  firstName: DS.attr("string")
  lastName:  DS.attr("string")
  email:  DS.attr("string")
  role:   DS.attr("string")
  password: DS.attr("string")

App.CurrentUser = App.User.extend({})


App.Room = DS.Model.extend
  name: DS.attr("string")
  roomUserState: DS.belongsTo("room_user_state")
  messages: DS.hasMany("message")


App.RoomUserState = DS.Model.extend
  userId: DS.attr("number")
  joined:  DS.attr("boolean")
  room:  DS.belongsTo("room")
  lastPingedAt: DS.attr("date")

#TODO move this elsewhere
App.RoomUserStateSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    room: {embedded: "load"}
  }
})


App.MessageSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    user: {embedded: "load"}
  }
})

App.Message = DS.Model.extend
  body: DS.attr("string")
  type: DS.attr("string")
  user: DS.belongsTo("user")
  room: DS.belongsTo("room")
  createdAt: DS.attr("string")

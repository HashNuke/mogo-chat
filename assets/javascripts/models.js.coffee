App.User = DS.Model.extend
  firstName: DS.attr("string")
  lastName:  DS.attr("string")
  email:  DS.attr("string")
  role:   DS.attr("string")
  password: DS.attr("string")


App.CurrentUser = App.User.extend({})


App.Room = DS.Model.extend
  name: DS.attr("string")
  room_user_state: DS.belongsTo("room_user_state")


App.RoomUserState = DS.Model.extend
  user_id: DS.attr("number")
  joined:  DS.attr("boolean")
  room:  DS.belongsTo("room")
  last_pinged_at: DS.attr("date")

#TODO move this elsewhere
App.RoomUserStateSerializer = DS.ActiveModelSerializer.extend(DS.EmbeddedRecordsMixin, {
  attrs: {
    room: {embedded: "always"}
  }
})

App.Message = DS.Model.extend
  body:   DS.attr("string")
  type:   DS.attr("string")
  roomId: DS.attr("string")
  userId: DS.attr("string")
  created_at: DS.attr("date")
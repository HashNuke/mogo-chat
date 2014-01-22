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
  user_id: DS.attr("integer")
  joined: DS.attr("boolean")
  last_pinged_at: DS.attr("datetime")
  room: DS.belongsTo("room")


App.Message = DS.Model.extend
  body:   DS.attr("string")
  type:   DS.attr("string")
  roomId: DS.attr("string")
  userId: DS.attr("string")

App.Room = DS.Model.extend
  name: DS.attr("string")
  roomUserState: DS.belongsTo("room_user_state")
  messages: DS.attr("array")
  users: DS.attr("array")
  isHistoryAvailable: DS.attr("boolean")

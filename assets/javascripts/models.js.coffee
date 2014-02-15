App.User = DS.Model.extend
  firstName: DS.attr("string")
  lastName:  DS.attr("string")
  email:  DS.attr("string")
  role:   DS.attr("string")
  password: DS.attr("string")
  color: DS.attr("string")
  authToken: DS.attr("string")

  isAdmin: (->
    @get("role") == "admin"
  ).property("role")


  borderStyle: (->
    "border-left: 0.2em solid #{@get("color")};"
  ).property("color")

  fontColor: (->
    "color: #{@get("color")};"
  ).property("color")


DS.ArrayTransform = DS.Transform.extend
  deserialize: (serialized)-> []
  serialize: (deserialized)-> []

App.register("transform:array", DS.ArrayTransform)

App.Room = DS.Model.extend
  name: DS.attr("string")
  roomUserState: DS.belongsTo("room_user_state")
  messages: DS.attr("array")
  users: DS.attr("array")
  isHistoryAvailable: DS.attr("boolean")


App.RoomUserState = DS.Model.extend
  userId: DS.attr("number")
  joined:  DS.attr("boolean")
  room:  DS.belongsTo("room")
  lastPingedAt: DS.attr("date")


App.Message = DS.Model.extend
  body: DS.attr("string")
  type: DS.attr("string")
  createdAt: DS.attr("string")
  errorPosting: DS.attr("boolean", defaultValue: false)
  user: DS.belongsTo("user")
  room: DS.belongsTo("room")

  link: (->
    "/rooms/#{@get("room.id")}/messages/#{@get("id")}"
  ).property(["id", "roomId"])

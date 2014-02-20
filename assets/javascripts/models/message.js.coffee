App.Message = DS.Model.extend
  body: DS.attr("string")
  formattedBody: DS.attr("string", defaultValue: "this is empty")
  type: DS.attr("string")
  createdAt: DS.attr("string")
  errorPosting: DS.attr("boolean", defaultValue: false)
  user: DS.belongsTo("user")
  room: DS.belongsTo("room")

  condensedBody: (->
    splitMsg = @get("body").split("\n")
    if splitMsg.length > 5
      newMsg = splitMsg.slice(0, 4)
      newMsg.push("...")
      newMsg.join("\n")
    else
      splitMsg.join("\n")
  ).property("body")

  link: (->
    "/rooms/#{@get("room.id")}/messages/#{@get("id")}"
  ).property(["id", "roomId"])

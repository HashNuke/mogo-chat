App.User = DS.Model.extend
  name: DS.attr("string")
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

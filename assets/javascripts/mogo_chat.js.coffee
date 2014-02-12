MogoChat = {}

#TODO This config should go in the db
MogoChat.config =
  messagesPerLoad: 20

class MogoChat.Plugins
  plugins: []

  register: (name, regex, callback)->
    for plugin in @plugins
      if plugin.name == name
        throw("Plugin with name \"#{name}\" already registered")
    @plugins.push({name, regex, callback})


  unregister: (name)->
    registeredIndex = null
    for plugin, index in @plugins
      if plugin.name == name
        registeredIndex = index
        break
    return false unless registeredIndex
    @plugins.splice(registeredIndex, 1)[0]


class MogoChat.PaintBox
  nextColor: 0
  colors: [
    "F57DBA"
    "829DE7"
    "77B546"
    "FFCC20"
    "A79D95"
    "809DAA"
    "9013FE"
    "637AB2"
    "BBAD7C"
    "C831DD"
    "71CCD3"
    "417505"
  ]

  getColor: ->
    color = @colors[@nextColor]
    @nextColor = @nextColor + 1
    if @nextColor >= @colors.length
      @nextColor = 0
    "##{color}"


window.MogoChat = MogoChat
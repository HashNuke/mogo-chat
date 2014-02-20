App.plugins.register "link", /(https?\:\S+)/g, (content, messageType, history)->
  if ["me", "text"].indexOf(messageType) != -1
    content.replace(/(https?\:\S+)/g, "<a target='_blank' href='$1'>$1</a>")
  else
    content

# Each plugin is registered with
#      * a name
#      * a regex
#      * a callback function
#
# Each message's body will be matched against the regex.
# If it matches, then the callback function is run.
#
# The callback function must return the body of the message.
# The body of the message can be modified if required (HTML allowed).
#
# The callback function is passed the following arguments:
#
#     * body of the message
#     * type of message ("text", "paste" or "me")
#     * a boolean variable which indicates if the message is live or history
#
# Use the third argument incase to check incase your plugin
# should work on live messages only.
#


# The following plugin detects links and replaces them with anchor tags
# It does it only for "me" and "text" messages
# and only returns the body for "paste" messages.

App.plugins.register "link", /(https?\:\S+)/g, (content, messageType, history)->  
  if ["me", "text"].indexOf(messageType) != -1
    content.replace(/(https?\:\S+)/g, "<a target='_blank' href='$1'>$1</a>")
  else          
    content

App.plugins.register "me", /^\/me /g, (content, messageType, history)->  
  if ["me"].indexOf(messageType) != -1
    emojify.replace(content.replace("/me ", ""))
  else          
    content    

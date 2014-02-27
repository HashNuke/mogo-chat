defmodule MogoChat.Templates do
  require EEx

  EEx.function_from_file :def, :index, "templates/index.html.eex", []
  EEx.function_from_file :def, :message, "templates/message.html.eex", [:message]
end
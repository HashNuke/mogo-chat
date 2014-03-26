defmodule MogoChat.Templates do
  require EEx

  EEx.function_from_file :def, :index, "templates/index.html.eex", [], [engine: HTMLEngine]
  EEx.function_from_file :def, :message, "templates/message.html.eex", [:message], [engine: HTMLEngine]
end
defmodule MogoChat.Controllers.Main do
  use Phoenix.Controller
  import MogoChat.ControllerUtils

  def index(conn) do
    {:safe, template} = MogoChat.Templates.index()
    html conn, template
  end

end

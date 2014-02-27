defmodule MogoChat.Controllers.Main do
  use Phoenix.Controller
  import MogoChat.ControllerUtils

  def index(conn) do
    html conn, MogoChat.Templates.index()
  end

end

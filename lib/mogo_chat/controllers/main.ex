defmodule MogoChat.Controllers.Main do
  use Phoenix.Controller
  import MogoChat.ControllerUtils

  def index(conn) do
    {:ok, contents} = File.read "templates/index.html"
    html conn, contents
  end


  def tryout(conn) do
    raise ArgumentError, message: "fghgfdh"
    text conn, "hi #{conn.params["username"]}, #{conn.params["password"]}"
  end

end

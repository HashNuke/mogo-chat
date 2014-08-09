defmodule MogoChat.AuthErrorHandler do
  @behaviour Plug.Wrapper

  import Plug.Conn
  import Phoenix.Controller.Connection
  import MogoChat.ControllerUtils

  def init(opts), do: opts

  def wrap(conn, _opts, fun) do
    try do
      fun.(conn)
    catch
      kind, %MogoChat.Errors.Unauthorized{message: reason} ->
        stacktrace = System.stacktrace
        if xhr?(conn) || hd(conn.path_info) == "api" do
          json_resp conn, 401, %{error: "Unauthorized! Please find some other property to trespass"}
        else
          redirect conn, "/#/login"
        end
    end
  end
end

defmodule MogoChat.AuthErrorHandler do
  @behaviour Plug.Wrapper

  import Plug.Connection
  import Phoenix.Controller

  def init(opts), do: opts

  def wrap(conn, _opts, fun) do
    try do
      fun.(conn)
    catch
      kind, MogoChat.Errors.Unauthorized[message: reason] ->
        stacktrace = System.stacktrace
        html conn, 401, "Unauthorized! Please find some other property to trespass"
    end
  end
end

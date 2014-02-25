defmodule MogoChat.AuthErrorHandler do
  @behaviour Plug.Wrapper

  import Plug.Connection
  import Phoenix.Controller

  def init(opts), do: opts

  def wrap(conn, _opts, fun) do
    try do
      fun.(conn)
      IO.inspect "it executes fine"
    catch
      kind, {{exception, application_trace}, _} ->
        # Check if this error can be handled by this plug
        if elem(exception, 0) == MogoChat.Errors.Unauthorized do
          stacktrace = System.stacktrace
          # send response to browser in case the error can be handled by this plug
          html conn, 401, "Unauthorized! Please find some other property to trespass"
        else
          # if not raise the same exception again to be handled elsewhere
          raise exception
        end
    end
  end
end

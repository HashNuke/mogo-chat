defmodule Phoenix.ErrorHandler do
  @behaviour Plug.Wrapper

  import Plug.Connection
  import Phoenix.Controller

  def init(opts), do: opts

  def wrap(conn, _opts, fun) do
    try do
      fun.(conn)
    catch
      kind, {{exception, application_trace}, _} ->
        stacktrace = System.stacktrace
        html conn, 500, "<html><h2>#{inspect exception}</h2><h4>Application trace</h4><pre>#{Exception.format_stacktrace application_trace}</pre><h4>Framework trace</h4><pre>#{Exception.format_stacktrace stacktrace}</pre></html>"

      kind, error ->
        stacktrace = System.stacktrace
        html conn, 500, "<html><h2>#{inspect error}</h2><h4>Application trace</h4><h4>Stacktrace</h4><pre>#{Exception.format_stacktrace stacktrace}</pre></html>"
    end
  end
end

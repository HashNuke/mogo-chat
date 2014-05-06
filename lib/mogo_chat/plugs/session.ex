defmodule Plugs.Session do
  import Plug.Conn

  @behaviour Plug.Wrapper

  def init(opts) do
    # Require a name for the session id cookie
    unless Keyword.has_key? opts, :name do
      raise ArgumentError, message: "Expected session name to be given."
    end

    unless Keyword.has_key? opts, :adapter do
      raise ArgumentError, message: "Expected session adapter to be given."
    else
      adapter = opts[:adapter]
    end

    adapter.init(opts)
  end

  def wrap(conn, opts, fun) do
    adapter = opts[:adapter]
    sid = conn 
      |> fetch_cookies
      |> get_sid(opts[:name])

    conn = conn |> put_resp_cookie(opts[:name], sid)

    data = adapter.get(sid)
    conn = conn |>
      assign(:session, data)
      |> assign(:session_adapter, adapter)
      |> assign(:session_id, sid)
      |> assign(:session_name, opts[:name])

    conn = fun.(conn)
    adapter.put(sid, conn.assigns[:session])

    conn
  end

  defp get_sid(conn, name) do
    if sid = conn.cookies[name] do
      sid
    else
      :crypto.strong_rand_bytes(96) |> :base64.encode
    end
  end
end

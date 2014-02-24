defmodule MogoChat.ControllerUtils do
  import Plug.Connection
  import Phoenix.Controller


  def json_decode(json) do
    {:ok, data} = JSEX.decode(json)
    data
  end


  def json_resp(conn, data, status \\ 200) do
    json conn, status, json_encode(data)
  end


  def json_encode(data) do
    {:ok, json} = JSEX.encode(data)
    json
  end


  def current_timestamp() do
    {{year, month, day}, {hour, minute, seconds}} = :calendar.universal_time()
    created_at = Ecto.DateTime.new(
      year: year,
      month: month,
      day: day,
      hour: hour,
      min: minute,
      sec: seconds)
  end


  def xhr?(conn) do
    headers = conn.req_headers
    headers["x-requested-with"] && Regex.match?(%r/xmlhttprequest/i, headers["x-requested-with"])
  end


  def authenticate_user!(conn) do
    user_id = conn.assigns[:session]
    if user_id do
      user = Repo.get(User, user_id)
      assign(conn, :current_user, user)
    else
      unauthorized!(conn)
    end
  end


  defp unauthorized!(conn) do
    if xhr?(conn) do
      send_response(conn, 401, "application/json", "")
    else
      redirect conn, "/#login"
    end
  end


  def authorize_if!(conn, condition) do
    user = conn.assigns[:current_user]
    is_authorized = apply(condition, [conn, user])

    unless is_authorized do
      unauthorized!(conn)
    end
  end


  def authorize_roles!(conn, allowed_roles) do
    user = conn.assigns[:current_user]

    unless :lists.member(user.role, allowed_roles) do
      unauthorized!(conn)
    end
  end


  def whitelist_params(params, allowed) do
    whitelist_params(params, allowed, [])
  end


  def whitelist_params(params, [], collected) do
    collected
  end


  def whitelist_params(params, allowed, collected) do
    [field | rest] = allowed
    if Dict.has_key?(params, field) do
      collected = ListDict.merge collected, [{ field, Dict.get(params, field) }]
    end
    whitelist_params(params, rest, collected)
  end


  def put_session(conn, user_id) do
    :ok = conn.assigns[:session_adapter].put(conn.assigns[:session_id], user_id)
    assign(conn, :session, user_id)
  end


  def destroy_session(conn) do
    apply(conn.assigns[:session_adapter], :delete, [conn.assigns[:session_id]])
    assign(conn, :session, nil)
  end
end

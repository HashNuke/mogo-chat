defmodule Mogo.RouterUtils do

  import Dynamo.HTTP.Session
  import Dynamo.HTTP.Halt
  import Dynamo.HTTP.Redirect


  def json_decode(json) do
    {:ok, data} = JSEX.decode(json)
    data
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


  def json_response(data, conn, status // 200) do
    conn.resp_content_type("application/json").resp status, json_encode(data)
  end


  def xhr?(conn) do
    headers = conn.req_headers
    headers["x-requested-with"] && Regex.match?(%r/xmlhttprequest/i, headers["x-requested-with"])
  end


  def authenticate_user!(conn) do
    user_id = get_session(conn, :user_id)
    if user_id do
      user = Repo.get(User, user_id)
      conn.assign(:current_user, user)
    else
      unauthorized!(conn)
    end
  end


  defp unauthorized!(conn) do
    if xhr?(conn) do
      halt! conn.status(401)
    else
      redirect! conn, to: "/#login", format: :html
    end
  end

  def authorize_user!(conn, allowed_roles) do
    user_id = get_session(conn, :user_id)

    if user_id do
      user = Repo.get(User, user_id)
      if :lists.member(user.role, allowed_roles) do
        conn = conn.assign(:current_user, user)
      else
        unauthorized!(conn)
      end
    else
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

end

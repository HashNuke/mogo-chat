defmodule SessionsApiRouter do
  use Dynamo.Router
  import Ecto.Query
  import MogoChat.RouterUtils


  get "/" do
    user_id = get_session conn, :user_id
    if user_id do
      user = Repo.get(User, user_id)
      attributes = User.attributes(user, ["id", "first_name", "last_name", "role", "email", "auth_token"])
      json_response [user: attributes], conn
    else
      json_response [error: "no session"], conn
    end
  end


  post "/" do
    params = conn.params
    login(conn, params["email"], params["password"])
  end


  delete "/" do
    json_response [ok: "logged out"], delete_session(conn, :user_id)
  end


  defp login(conn, email, password) when email == nil or password == nil do
    json_response [error: "Please check your login credentials."], conn, 401
  end

  defp login(conn, email, password) do
    query = from u in User, where: u.email == ^email
    users = Repo.all query

    case length(users) > 0 do
      true ->
        user = users |> hd
        if User.valid_password?(user, password) do
          conn = put_session(conn, :user_id, user.id)
          user_attributes = User.attributes(user, ["id", "first_name", "last_name", "role", "email", "auth_token"])
          json_response [user: user_attributes], conn
        else
          json_response [error: "Please check your login credentials."], conn, 401
        end
      false ->
        json_response [error: "Maybe you don't have an account?"], conn, 401
    end
  end

end

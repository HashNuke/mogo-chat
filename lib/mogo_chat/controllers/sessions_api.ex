defmodule MogoChat.Controllers.SessionsApi do
  use Phoenix.Controller
  import Ecto.Query
  import MogoChat.ControllerUtils


  def index(conn) do
    user_id = conn.assigns[:session]
    if user_id do
      user = Repo.get(User, user_id)
      attributes = User.attributes(user, ["id", "name", "role", "email", "auth_token"])
      json_resp conn, [user: attributes]
    else
      json_resp conn, [error: "no session"]
    end
  end


  def create(conn) do
    params = conn.params
    login(conn, params["email"], params["password"])
  end


  def destroy(conn) do
    json_resp destroy_session(conn), [ok: "logged out"]
  end


  defp login(conn, email, password) when email == nil or password == nil do
    json_resp conn, [error: "Please check your login credentials."], 401
  end


  defp login(conn, email, password) do
    query = from u in User, where: u.email == ^email
    users = Repo.all query

    case length(users) > 0 do
      true ->
        user = users |> hd
        if User.valid_password?(user, password) do
          conn = put_session(conn, user.id)
          user_attributes = User.attributes(user, ["id", "name", "role", "email", "auth_token"])
          json_resp conn, [user: user_attributes]
        else
          json_resp conn, [error: "Please check your login credentials."], 401
        end
      false ->
        json_resp conn, [error: "Maybe you don't have an account?"], 401
    end
  end

end

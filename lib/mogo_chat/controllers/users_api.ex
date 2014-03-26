defmodule MogoChat.Controllers.UsersApi do
  use Phoenix.Controller
  import Ecto.Query
  import MogoChat.ControllerUtils


  def index(conn) do
    conn = authenticate_user!(conn)
    authorize_roles!(conn, ["admin"])

    users = Repo.all(from u in User, where: u.archived == ^false)
    users_attributes = lc user inlist users do
      User.attributes(user, ["id", "name", "role", "email", "auth_token"])
    end
    json_resp conn, [users: users_attributes]
  end


  def create(conn) do
    conn = authenticate_user!(conn)
    authorize_roles!(conn, ["admin"])

    params = conn.params
    user_params = whitelist_params(params["user"], ["name", "email", "password", "role"])

    user = User.new(user_params)
    |> User.encrypt_password()
    |> User.assign_auth_token()

    case User.validate(user) do
      [] ->
        saved_user = Repo.create(user)
        json_resp conn, [user: User.public_attributes(saved_user)]
      errors ->
        json_resp conn, [errors: errors], 422
    end
  end


  def show(conn) do
    conn = authenticate_user!(conn)
    authorize_if! conn, fn(conn, user)->
      user_id = binary_to_integer(conn.params["user_id"])

      cond do
        user.id == user_id || user.role == "admin" ->
          true
        true ->
          false
      end
    end

    user_id = conn.params["user_id"]
    # TODO user query to not return archived users
    user = Repo.get User, user_id
    user_attributes = User.attributes(user, ["id", "name", "role", "email", "auth_token", "archived"])
    json_resp conn, [user: user_attributes]
  end


  def update(conn) do
    conn = authenticate_user!(conn)
    authorize_if! conn, fn(conn, user)->
      user_id = binary_to_integer(conn.params["user_id"])

      cond do
        user.id == user_id || user.role == "admin" ->
          true
        true ->
          false
      end
    end

    user_id = conn.params["user_id"]
    params = conn.params
    current_user = conn.assigns[:current_user]
    whitelist = ["name", "email", "password"]
    if current_user.role == "admin" do
      whitelist = whitelist ++ ["role"]
    end

    user_params = whitelist_params(params["user"], whitelist)
    # TODO use query to not fetch archived users
    user = Repo.get(User, user_id).update(user_params)
    |> User.encrypt_password()

    case User.validate(user) do
      [] ->
        # NOTE commenting this out because someone
        # seems to be changing the password
        # in the demo app
        # :ok = Repo.update(user)
        json_resp conn, [user: User.public_attributes(user)]
      errors ->
        json_resp conn, [errors: errors], 422
    end
  end


  def destroy(conn) do
    conn = authenticate_user!(conn)
    authorize_roles!(conn, ["admin"])

    user_id = binary_to_integer(conn.params["user_id"])
    current_user_id = conn.assigns[:current_user].id
    if current_user_id != user_id do
      new_attrs = [archived: true, email: nil, auth_token: nil, encrypted_password: nil]
      updated_user = Repo.get(User, user_id).update(new_attrs)
      :ok = Repo.update(updated_user)

      Repo.delete_all(from rus in RoomUserState, where: rus.user_id == ^user_id)
    end
    json_resp conn, ""
  end

end
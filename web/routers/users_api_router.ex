defmodule UsersApiRouter do
  use Dynamo.Router
  use Ecto.Query
  import Cobalt.RouterUtils

  prepare do
    authorize_user!(conn, ["admin"])
  end


  get "/" do
    users = Repo.all User
    users_attributes = lc user inlist users do
      User.attributes(user, ["id", "first_name", "last_name", "role", "email"])
    end
    json_response([users: users_attributes], conn)
  end


  post "/" do
    user_id = conn.params[:user_id]
    {:ok, params} = conn.req_body
    |> JSEX.decode

    user_params = whitelist_params(params, ["first_name", "last_name", "username", "password", "role"])
    user = User.new(user_params).encrypt_password()

    case User.validate(user) do
      [] ->
        json_response [user: Repo.create(user)], conn
      errors ->
        json_response [errors: errors], conn, 422
    end
  end


  get "/:user_id" do
    user_id = conn.params["user_id"]
    user = Repo.get User, user_id
    json_response [user: User.public_attributes(user)], conn
  end


  post "/:user_id" do
    user_id = conn.params[:user_id]
    {:ok, params} = conn.req_body
    |> JSEX.decode

    user_params = whitelist_params(params, ["first_name", "last_name", "username", "password", "role"])
    user = Repo.get(User, user_id).update(user_params).encrypt_password()

    case User.validate(user) do
      [] ->
        json_response [user: Repo.update(user)], conn
      errors ->
        json_response [errors: errors], conn, 422
    end
  end


  delete "/:user_id" do
    user_id = conn.params["user_id"]
    query = from u in User, where: u.id == ^user_id
    Repo.delete query
    json_response([ok: user_id], conn)
  end

end

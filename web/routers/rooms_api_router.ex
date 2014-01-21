defmodule RoomsApiRouter do
  use Dynamo.Router
  use Ecto.Query
  import Cobalt.RouterUtils

  prepare do
    authorize_user!(conn, ["admin"])
  end


  get "/" do
    rooms = Repo.all Room
    lc room inlist rooms do
      room.public_attributes
    end
    |> &([rooms: &1])
    |> json_response(conn)
  end


  post "/" do
    {:ok, params} = conn.req_body
    |> JSEX.decode

    params = whitelist_params(params["room"], ["name"])
    room = Room.new params["room"]

    case Room.validate(room) do
      [] ->
        saved_room = Repo.create(room)
        json_response [room: Room.public_attributes(saved_room)], conn
      errors ->
        json_response [errors: errors], conn
    end
  end


  put "/:room_id" do
    room_id = conn.params[:room_id]
    {:ok, params} = conn.req_body
    |> JSEX.decode

    room_params = whitelist_params(params["room"], ["name"])
    room = Repo.get(Room, room_id).update(room_params)
    |> Room.encrypt_password()

    case Room.validate(room) do
      [] ->
        :ok = Repo.update(room)
        json_response [user: Room.public_attributes(room)], conn
      errors ->
        json_response [errors: errors], conn, 422
    end
  end


  delete "/:room_id" do
    room_id = conn.params["room_id"]
    query = from r in Room, where: r.id == ^room_id
    Repo.delete_all query
    json_response("", conn)
  end

end

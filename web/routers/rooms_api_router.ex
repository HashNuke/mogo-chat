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
        json_response [room: Repo.create(room)], conn
      errors ->
        json_response [errors: errors], conn
    end
  end


  delete "/:room_id" do
    room_id = conn.params["room_id"]
    query = from r in Room, where: r.id == ^room_id
    Repo.delete_all query
    json_response("", conn)
  end

end

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

    #TODO
    # params = whitelist_params(params["room"], ["name"])
    # room = Room.new params["room"]
    # 
    # case Repo.create(room) do
    #   {:ok, key} ->
    #     json_response [room: domain.id(key)], conn
    #   {:error, domain} ->
    #     json_response [errors: domain.errors], conn
    # end
  end

  #TODO
  # delete "/:domain_id" do
  #   domain_id = conn.params["domain_id"]
  #   Domain.destroy domain_id
  #   json_response("", conn)
  # end

end

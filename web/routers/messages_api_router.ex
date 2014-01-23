defmodule MessagesApiRouter do
  use Dynamo.Router
  use Ecto.Query
  import Cheko.RouterUtils

  prepare do
    authenticate_user!(conn)
  end


  get "/:room_id" do
    room_id = conn.params[:room_id]
    room = Repo.get Room, room_id

    [room: Room.public_attributes(room)]
    |> json_response(conn)
  end


  post "/" do
    user_id = get_session(conn, :user_id)
    params = ExJSON.parse conn.req_body

    #TODO check if room with the room_id exists

    message_params = whitelist_params(params["message"], ["room_id", "body"])
    {{year, month, day}, {hour, minute, seconds}} = :erlang.localtime()
    created_at = Ecto.DateTime.new(
      year: year,
      month: month,
      day: day,
      hour: hour,
      min: minute,
      sec: seconds)
    message = Message.new(
      body: message_params["body"],
      room_id: binary_to_integer(message_params["room_id"]),
      user_id: user_id,
      created_at: created_at
    ) |> Message.assign_message_type()

    case Message.validate(message) do
      [] ->
        saved_message = Repo.create(message)
        json_response [message: Message.public_attributes(saved_message)], conn
      errors ->
        json_response [errors: errors], conn
    end
  end

end

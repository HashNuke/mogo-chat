defmodule MessagesApiRouter do
  use Dynamo.Router
  import Ecto.Query
  import MogoChat.RouterUtils

  prepare do
    authenticate_user!(conn)
  end


  get "/:room_id" do
    user_id = get_session(conn, :user_id)
    before_message_id = conn.params[:before]
    after_message_id  = conn.params[:after]
    room = Repo.get Room, binary_to_integer(conn.params[:room_id])

    query = cond do
      before_message_id ->
        before_message_id = binary_to_integer(before_message_id)
        from m in Message,
          order_by: [desc: m.created_at],
          limit: 20,
          preload: :user,
          where: m.room_id == ^room.id and m.id < ^before_message_id

      after_message_id ->
        after_message_id = binary_to_integer(after_message_id)
        from m in Message,
          order_by: [desc: m.created_at],
          limit: 20,
          preload: :user,
          where: m.room_id == ^room.id and m.id > ^after_message_id

      true ->
        from m in Message,
          order_by: [desc: m.created_at],
          limit: 20,
          preload: :user,
          where: m.room_id == ^room.id
    end


    room_state_query = from r in RoomUserState,
      where: r.room_id == ^room.id and r.user_id == ^user_id

    [room_state] = Repo.all room_state_query
    room_state.update([last_pinged_at: current_timestamp()])
    |> Repo.update()

    messages_attributes = lc message inlist Repo.all(query) do
      Dict.merge Message.public_attributes(message), [user: User.public_attributes(message.user.get)]
    end

    if !before_message_id && !after_message_id do
      messages_attributes = Enum.reverse(messages_attributes)
    end
    [messages: messages_attributes]
    |> json_response(conn)
  end


  post "/" do
    user_id = get_session(conn, :user_id)
    params = json_decode conn.req_body

    #TODO check if room with the room_id exists
    message_params = whitelist_params(params["message"], ["room_id", "body"])

    message = Message.new(
      body: message_params["body"],
      room_id: binary_to_integer(message_params["room_id"]),
      user_id: user_id,
      created_at: current_timestamp()
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

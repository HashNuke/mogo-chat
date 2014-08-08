defmodule MogoChat.Controllers.MessagesApi do
  use Phoenix.Controller
  import Ecto.Query
  import MogoChat.ControllerUtils


  def index(conn) do
    conn = authenticate_user!(conn)
    user_id = conn.assigns[:current_user].id
    before_message_id = conn.params["before"]
    after_message_id  = conn.params["after"]
    room = Repo.get Room, String.to_integer(conn.params["room_id"])

    query = cond do
      before_message_id ->
        before_message_id = String.to_integer(before_message_id)
        from m in Message,
          order_by: [desc: m.created_at],
          limit: 20,
          preload: :user,
          where: m.room_id == ^room.id and m.id < ^before_message_id

      after_message_id ->
        after_message_id = String.to_integer(after_message_id)
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

    messages_attributes = Enum.map Repo.all(query), fn(message)->
      Dict.merge Message.public_attributes(message), [user: User.public_attributes(message.user.get)]
    end

    if !before_message_id do
      messages_attributes = Enum.reverse(messages_attributes)
    end

    json conn, [messages: messages_attributes]
  end


  def create(conn) do
    conn = authenticate_user!(conn)
    user_id = conn.assigns[:current_user].id
    params = conn.params

    message_params = whitelist_params(params["message"], ["room_id", "body"])
    room = Repo.get Room, message_params["room_id"]

    message = Message.new(
      body: message_params["body"],
      room_id: room.id,
      user_id: user_id,
      created_at: current_timestamp()
    )
    |> Message.assign_message_type()

    case Message.validate(message) do
      [] ->
        saved_message = Repo.create(message)
        json conn, [message: Message.public_attributes(saved_message)]
      errors ->
        json conn, [errors: errors]
    end
  end

end

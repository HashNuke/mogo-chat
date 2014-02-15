defmodule RoomMessagesRouter do
  use Dynamo.Router
  import Ecto.Query
  import MogoChat.RouterUtils

  prepare do
    conn = conn.assign(:layout, nil)
    authenticate_user!(conn)
  end

  get "/:room_id/messages/:message_id" do
    message_id = binary_to_integer(conn.params[:message_id])
    room_id = binary_to_integer(conn.params[:room_id])
    query   = from m in Message,
      where: m.id == ^message_id and m.room_id == ^room_id,
      preload: :user

    [message] = Repo.all query
    message_params = message.__entity__(:keywords)
    user_params = message.user.get.__entity__(:keywords)
    conn = conn.assign(:message, message_params ++ [user: user_params])

    render conn, "message.html"
  end

end

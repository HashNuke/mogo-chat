defmodule RoomMessagesRouter do
  use Dynamo.Router
  import Ecto.Query
  import MogoChat.RouterUtils

  prepare do
    authenticate_user!(conn)
  end

  post "/:room_id/messages/:message_id" do
    message_id = binary_to_integer(conn.params[:message_id])
    room_id = binary_to_integer(conn.params[:room_id])
    query   = from m in Message, where: m.id == ^message_id and m.room_id == ^room_id
    [message] = Repo.all query
    conn.assign("message", message)

    render conn, "message.html"
  end

end
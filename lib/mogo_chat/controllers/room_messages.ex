defmodule MogoChat.Controllers.RoomMessages do
  use Phoenix.Controller
  import Ecto.Query
  import MogoChat.ControllerUtils


  def show(conn) do
    conn = authenticate_user!(conn)
    message_id = binary_to_integer(conn.params["message_id"])
    room_id = binary_to_integer(conn.params["room_id"])
    query   = from m in Message,
      where: m.id == ^message_id and m.room_id == ^room_id,
      preload: :user

    [message] = Repo.all query
    message_params = message.__entity__(:keywords)
    user_params = message.user.get.__entity__(:keywords)
    message = message_params ++ [user: user_params]

    html conn, MogoChat.Templates.message(message)
  end

end

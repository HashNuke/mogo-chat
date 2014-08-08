defmodule MogoChat.Controllers.RoomMessages do
  use Phoenix.Controller
  import Ecto.Query
  import MogoChat.ControllerUtils


  def show(conn) do
    conn = authenticate_user!(conn)
    message_id = String.to_integer(conn.params["message_id"])
    room_id = String.to_integer(conn.params["room_id"])
    query   = from m in Message,
      where: m.id == ^message_id and m.room_id == ^room_id,
      preload: :user

    [message] = Repo.all query
    message_params = message.__entity__(:keywords)
    user_params = message.user.get.__entity__(:keywords)
    message = message_params ++ [user: user_params]

    {:safe, template} = MogoChat.Templates.message(message)
    html conn, template
  end

end

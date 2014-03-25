defmodule MogoChat.Controllers.RoomsApi do
  use Phoenix.Controller
  import Ecto.Query
  import MogoChat.ControllerUtils


  def active_users(conn) do
    authenticate_user!(conn)

    room_id = binary_to_integer(conn.params["room_id"])
    room = Repo.get Room, room_id
    now  = current_timestamp()
    seconds_ago = now.sec(now.sec - 7)
    query = from s in RoomUserState,
      where: s.room_id == ^room.id,
      order_by: s.id,
      preload: :user

    users_attributes = lc room_user_state inlist Repo.all(query) do
      User.public_attributes(room_user_state.user.get)
    end

    json_resp conn, [users: users_attributes]
  end


  def index(conn) do
    authenticate_user!(conn)

    rooms = Repo.all Room
    rooms_attributes = lc room inlist rooms do
      Room.public_attributes(room)
      end
    json_resp conn, [rooms: rooms_attributes]
  end


  def show(conn) do
    conn = authenticate_user!(conn)

    room_id = conn.params["room_id"]
    room = Repo.get Room, room_id

    json_resp conn, [room: Room.public_attributes(room)]
  end


  def create(conn) do
    conn = authenticate_user!(conn)
    authorize_roles!(conn, ["admin"])

    params = conn.params

    room_params = whitelist_params(params["room"], ["name"])
    room = Room.new room_params

    case Room.validate(room) do
      [] ->
        room = Repo.create(room)
        json_resp conn, [room: Room.public_attributes(room)]
      errors ->
        json_resp conn, [errors: errors], 422
    end
  end


  def update(conn) do
    conn = authenticate_user!(conn)
    authorize_roles!(conn, ["admin"])

    room_id = conn.params["room_id"]
    params = conn.params

    room_params = whitelist_params(params["room"], ["name"])
    room = Repo.get(Room, room_id).update(room_params)

    case Room.validate(room) do
      [] ->
        :ok = Repo.update(room)
        json_resp conn, [user: Room.public_attributes(room)]
      errors ->
        json_resp conn, [errors: errors], 422
    end
  end


  def destroy(conn) do
    conn = authenticate_user!(conn)
    authorize_roles!(conn, ["admin"])

    room_id = binary_to_integer(conn.params["room_id"])

    # Note instead of fetching it and deleting it
    # just create a new record and delete it
    room = Room.new(id: room_id)
    Repo.delete room

    # Delete all messages
    Repo.delete_all(from m in Message, where: m.room_id == ^room_id)

    # Delete the room user states
    Repo.delete_all(from rus in RoomUserState, where: rus.room_id == ^room_id)

    json_resp conn, ""
  end

end
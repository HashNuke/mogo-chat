defmodule MogoChat.Controllers.RoomUserStatesApi do
  use Phoenix.Controller
  import Ecto.Query
  import MogoChat.ControllerUtils

  def show(conn) do
    conn = authenticate_user!(conn)
    user_id = conn.assigns[:session]
    rooms = Repo.all(Room)

    room_user_states_attributes = Enum.map rooms, fn(room)->
      query = from r in RoomUserState,
        where: r.user_id == ^user_id and r.room_id == ^room.id,
        preload: :user

      result = Repo.all query
      if length(result) == 0 do
        room_user_state = RoomUserState.new(user_id: user_id, room_id: room.id, joined: false)
        room_user_state = Repo.create(room_user_state)
        get_query = from r in RoomUserState,
          where: r.id == ^room_user_state.id,
          preload: :user

        [room_user_state] = Repo.all get_query

        RoomUserState.public_attributes(room_user_state) ++ [room: Room.public_attributes(room)] ++ [user: User.public_attributes(room_user_state.user.get)]
      else
        [room_user_state|_] = result
        RoomUserState.public_attributes(room_user_state) ++ [room: Room.public_attributes(room)] ++ [user: User.public_attributes(room_user_state.user.get)]
      end
    end

    json_resp conn, [room_user_states: room_user_states_attributes]
  end


  def update(conn) do
    conn = authenticate_user!(conn)
    room_user_state_id = binary_to_integer(conn.params["room_user_state_id"])
    user_id = conn.assigns[:session]
    params = conn.params

    room_user_state_params = whitelist_params(params["room_user_state"], ["joined"])
    query = from r in RoomUserState,
      where: r.id == ^room_user_state_id and r.user_id == ^user_id

    [room_user_state] = Repo.all query
    new_room_user_state = room_user_state.update(room_user_state_params)

    case RoomUserState.validate(new_room_user_state) do
      [] ->
        :ok = Repo.update(new_room_user_state)
        json_resp conn, [user: RoomUserState.public_attributes(new_room_user_state)]
      errors ->
        json_resp conn, [errors: errors], 422
    end
  end

end

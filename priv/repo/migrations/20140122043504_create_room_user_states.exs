defmodule Repo.Migrations.CreateRoomUserStates do
  use Ecto.Migration

  def up do
    "CREATE TABLE IF NOT EXISTS room_user_states(id serial primary key, user_id integer, room_id integer, joined boolean, last_pinged_at timestamp)"
  end

  def down do
    "DROP TABLE room_user_states"
  end

end

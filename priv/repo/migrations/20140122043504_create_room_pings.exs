defmodule Repo.Migrations.CreateRoomPings do
  use Ecto.Migration

  def up do
    "CREATE TABLE IF NOT EXISTS room_pings(id serial primary key, user_id integer, room_id integer, pinged_at timestamp)"
  end

  def down do
    "DROP TABLE room_pings"
  end

end

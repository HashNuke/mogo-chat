defmodule Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def up do
    "CREATE TABLE IF NOT EXISTS rooms(id serial primary key, name text)"
  end

  def down do
    "DROP TABLE rooms"
  end
end

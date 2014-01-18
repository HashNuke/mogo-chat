defmodule Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def up do
    "CREATE TABLE IF NOT EXISTS messages(id serial primary key, body text, type text, user_id integer, room_id integer, created_at timestamp)"
  end

  def down do
    "DROP TABLE messages"
  end
end

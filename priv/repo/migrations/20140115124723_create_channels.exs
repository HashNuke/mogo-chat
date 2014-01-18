defmodule Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def up do
    "CREATE TABLE IF NOT EXISTS channels(id serial primary key, name text)"
  end

  def down do
    "DROP TABLE channels"
  end
end

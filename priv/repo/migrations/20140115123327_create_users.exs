defmodule Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    "CREATE TABLE IF NOT EXISTS users(id serial primary key, name text, email text, role text, encrypted_password text, auth_token text, archived boolean DEFAULT FALSE)"
  end

  def down do
    "DROP TABLE users"
  end
end

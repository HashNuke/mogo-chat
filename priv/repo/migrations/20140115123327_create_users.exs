defmodule Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    "CREATE TABLE IF NOT EXISTS users(id serial primary key, first_name text, last_name text, email text, role text, encrypted_password text, auth_token text)"
  end

  def down do
    "DROP TABLE users"
  end
end

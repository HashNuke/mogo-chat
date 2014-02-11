defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres
  import AppConfig

  read_db_config

  def priv do
    app_dir(:mogo_chat, "priv/repo")
  end
end

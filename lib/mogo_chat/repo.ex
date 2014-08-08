defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres


  def conf do
    cond do
      System.get_env("STACK") == "cedar" ->
        parse_url System.get_env("DATABASE_URL")
      true ->
        parse_url Application.get_env(:mogo_chat, :db_url)
    end
  end


  def priv do
    app_dir(:mogo_chat, "priv/repo")
  end
end

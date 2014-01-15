defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def url do
    case Mix.env do
      :test ->
        "ecto://postgres:postgres@localhost/hym_test"
      :dev ->
        "ecto://postgres:postgres@localhost/hym_development"
      _ ->
        "ecto://postgres:postgres@localhost/hym_production"
    end
  end
end
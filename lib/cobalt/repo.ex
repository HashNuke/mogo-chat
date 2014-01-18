defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres
  import Cobalt.ModelUtils

  def url do
    case Mix.env do
      :test ->
        "ecto://akashmanohar:akash123@localhost/cobalt_test"
      :dev ->
        "ecto://akashmanohar:akash123@localhost/cobalt_development"
      _ ->
        "ecto://akashmanohar:akash123@localhost/cobalt_production"
    end
  end


  def priv do
    app_dir(:cobalt, "priv/repo")
  end
end
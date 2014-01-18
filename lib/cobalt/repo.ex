defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def url do
    case Mix.env do
      :test ->
        "ecto://akashmanohar:akash123@localhost/hym_test"
      :dev ->
        "ecto://akashmanohar:akash123@localhost/hym_development"
      _ ->
        "ecto://akashmanohar:akash123@localhost/hym_production"
    end
  end


  def priv do
    app_dir(:hym, "priv/repo")
  end
end
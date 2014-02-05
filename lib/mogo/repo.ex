defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def url do
    case Mix.env do
      :test ->
        "ecto://akashmanohar:akash123@localhost/cheko_test"
      :dev ->
        "ecto://akashmanohar:akash123@localhost/cheko_development"
      _ ->
        "ecto://akashmanohar:akash123@localhost/cheko_production"
    end
  end


  def priv do
    app_dir(:mogo, "priv/repo")
  end
end
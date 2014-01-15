defmodule Channel do
  use Ecto.Model

  queryable "channels" do
    field :name, :string
  end
end

defmodule Room do
  use Ecto.Model

  queryable "rooms" do
    field :name, :string
  end
end

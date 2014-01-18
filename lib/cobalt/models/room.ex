defmodule Room do
  use Ecto.Model

  queryable "rooms" do
    field :name, :string
  end

  validate room,
    name: has_length(1..30)

end

defmodule Room do
  use Ecto.Model
  import Cobalt.ModelUtils

  queryable "rooms" do
    field :name, :string
  end

  validate room,
    name: has_length(1..30)

  def public_attributes(record) do
    attributes(record, ["id", "name"])
  end

end

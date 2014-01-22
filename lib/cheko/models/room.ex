defmodule Room do
  use Ecto.Model
  use Cheko.ModelUtils

  queryable "rooms" do
    field :name, :string
    has_many :messages, Message
    has_many :room_pings, RoomPing
  end

  validate room,
    name: has_length(1..30)

  def public_attributes(record) do
    attributes(record, ["id", "name"])
  end

end

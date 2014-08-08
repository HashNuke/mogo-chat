defmodule Room do
  use Ecto.Model
  use MogoChat.ModelUtils

  schema "rooms" do
    field :name, :string
    has_many :messages, Message
    has_many :room_user_states, RoomUserState
  end

  validate room,
    name: present(),
    name: has_length(1..30)

  def public_attributes(record) do
    attributes(record, ["id", "name"])
  end

end

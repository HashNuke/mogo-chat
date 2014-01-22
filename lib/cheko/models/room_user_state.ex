defmodule RoomUserState do
  use Ecto.Model
  use Cheko.ModelUtils

  queryable "room_user_states" do
    belongs_to :user, User
    belongs_to :room, Room
    field :joined, :boolean
    field :last_pinged_at, :datetime
  end


  validate room_user_state,
    user_id: present(),
    room_id: present(),
    joined: member_of([true, false])


  def public_attributes(record) do
    attributes(record, ["id", "room_id", "user_id", "joined", "last_pinged_at"])
  end

end

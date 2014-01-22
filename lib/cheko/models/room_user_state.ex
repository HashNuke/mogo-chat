defmodule RoomUserState do
  use Ecto.Model
  use Cheko.ModelUtils

  queryable "room_user_states" do
    belongs_to :user, User
    belongs_to :room, Room
    field :last_pinged_at, :datetime
  end
end

defmodule RoomPing do
  use Ecto.Model
  use Cheko.ModelUtils

  queryable "room_pings" do
    belongs_to :user, User
    belongs_to :room, Room
    field :pinged_at, :datetime
  end
end

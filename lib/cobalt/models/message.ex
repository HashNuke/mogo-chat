defmodule Message do
  use Ecto.Model
  use Cheko.ModelUtils

  queryable "messages" do
    field :body,       :string
    field :type,       :string
    field :created_at, :datetime
    belongs_to :room, Room
    belongs_to :user, User
  end

end
defmodule Message do
  use Ecto.Model
  use Cobalt.ModelUtils

  queryable "messages" do
    field :body,       :string
    field :type,       :string
    field :user_id,    :integer
    field :created_at, :datetime
    belongs_to :room, Room
    belongs_to :user, User
  end

end
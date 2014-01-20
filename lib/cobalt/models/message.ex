defmodule Message do
  use Ecto.Model
  use Cobalt.ModelUtils

  queryable "messages" do
    field :body,       :string
    field :type,       :string
    field :room_id,    :integer
    field :user_id,    :integer
    field :created_at, :datetime
  end

end
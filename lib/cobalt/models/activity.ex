defmodule Activity do
  use Ecto.Model

  queryable "activities" do
    field :body,       :string
    field :type,       :string
    field :channel_id, :integer
    field :user_id,    :integer
    field :created_at, :datetime
  end
end

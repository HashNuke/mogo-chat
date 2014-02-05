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


  def assign_message_type(record) do
    if Regex.match?(%r/\n/, record.body) do
      record.type("paste")
    else
      record.type("text")
    end
  end


  validate message,
    user_id: present(),
    room_id: present(),
    body:    present(),
    type:    member_of(["text", "paste"]),
    created_at: present()


  def public_attributes(record) do
    attrs = attributes(record, ["id", "room_id", "user_id", "body", "type"])
    attrs ++ [created_at: timestamp(record.created_at)]
  end

end
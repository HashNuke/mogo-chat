defmodule Message do
  use Ecto.Model
  use MogoChat.ModelUtils

  queryable "messages" do
    field :body,       :string
    field :type,       :string
    field :created_at, :datetime
    belongs_to :room, Room
    belongs_to :user, User
  end


  def assign_message_type(record) do
    cond do
      Regex.match?(~r/\n/, record.body) ->
        record.type("paste")
      #TODO support sounds
      # matches = Regex.named_captures(~r/\/play (?<sound>\w+)/, record.body) ->
      #   record.type("sound").body(matches[:sound])
      matches = Regex.named_captures(~r/^\/me (?<announcement>.+)/, record.body) ->
        record.type("me").body(matches[:announcement])
      true ->
        record = record.body
          |> String.strip()
          |> record.body()
        record.type("text")
    end
  end


  validate message,
    user_id: present(),
    room_id: present(),
    body:    present(),
    type:    member_of(["text", "paste", "me", "sound"]),
    created_at: present()


  def public_attributes(record) do
    attrs = attributes(record, ["id", "room_id", "user_id", "body", "type"])
    attrs ++ [created_at: timestamp(record.created_at)]
  end

end

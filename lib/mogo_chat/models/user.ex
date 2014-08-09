defmodule User do
  use Ecto.Model
  use MogoChat.ModelUtils

  schema "users" do
    field :email,      :string
    field :encrypted_password, :string
    field :role,       :string
    field :name, :string
    field :password,   :virtual, default: nil
    field :auth_token, :string
    field :archived, :boolean
    has_many :messages, Message
    has_many :room_user_states, RoomUserState
  end


  validate user,
    name:  present(),
    name:  has_length(min: 3),
    email: present(),
    role:  member_of(~w(admin member)),
    also:  validate_password


  def validate_password(user) do
    if !user.encrypted_password || (user.password && String.length(user.password) < 6) do
      %{password: "should be 6 characters or more"}
    else
      %{}
    end
  end


  def valid_password?(record, password) do
    salt = String.slice(record.encrypted_password, 0, 29)
    {:ok, hashed_password} = :bcrypt.hashpw(password, salt)
    "#{hashed_password}" == record.encrypted_password
  end


  def public_attributes(record) do
    attributes(record, ["id", "name", "role", "archived"])
  end

  def assign_auth_token(record) do
    "#{:uuid.get_v4() |> :uuid.uuid_to_string()}"
    |> record.auth_token()
  end

  def encrypt_password(record) do
    if record.password != nil do
      {:ok, salt} = :bcrypt.gen_salt()
      {:ok, hashed_password} = :bcrypt.hashpw(record.password, salt)
      record = record.encrypted_password("#{hashed_password}")
    end
    record
  end
end

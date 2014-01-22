defmodule User do
  use Ecto.Model
  use Cheko.ModelUtils

  queryable "users" do
    field :email,      :string
    field :encrypted_password, :string
    field :role,       :string
    field :first_name, :string
    field :last_name,  :string
    field :password,   :virtual, default: nil
    has_many :messages, Message
    has_many :room_pings, RoomPing
  end


  validate user,
    email: present(),
    role: member_of(%w(admin member)),
    first_name: has_length(min: 3),
    also: validate_password


  def validate_password(user) do
    if !user.encrypted_password || (user.password && size(user.password) < 6) do
      [{ :password, "should be 6 characters or more" }]
    else
      []
    end
  end


  def valid_password?(record, password) do
    salt = String.slice(record.encrypted_password, 0, 29)
    {:ok, hashed_password} = :bcrypt.hashpw(password, salt)
    "#{hashed_password}" == record.encrypted_password
  end


  def public_attributes(record) do
    attributes(record, ["id", "first_name", "last_name", "role"])
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

defmodule User do
  use Ecto.Model

  queryable "users" do
    field :email,      :string
    field :encrypted_password, :string
    field :role,       :string
    field :first_name, :string
    field :last_name,  :string
    field :password,   :virtual, default: nil
  end


  validate user,
    first_name: present(),
    encrypted_password: present(),
    also: validate_password


  def validate_password(user) do
    if user.password && size(user.password) < 6 do
      [{ :password, "should be 6 characters or more" }]
    else
      []
    end
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

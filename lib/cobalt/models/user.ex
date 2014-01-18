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
    also: custom_validations


  validatep custom_validations(user),
    password: validate_password


  def validate_password(attr, value, opts // []) do
    if value && size(value) < 6 do
      [{ attr, opts[:message] || "should be 6 characters or more" }]
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

defmodule User do
  use Ecto.Model

  queryable "users" do
    field :email,      :string
    field :encrypted_password, :string
    field :role,       :string
    field :first_name, :string
    field :last_name,  :string
  end
end

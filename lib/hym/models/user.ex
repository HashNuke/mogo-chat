defmodule User do
  use Ecto.Model

  queryable "users" do
    field :first_name,         :string
    field :last_name,          :string
    field :email,              :string
    field :encrypted_password, :string
  end
end

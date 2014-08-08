case Mix.env do
  :test ->
    config :firebrick, [db_url: "ecto://postgres_username:password@localhost/mogo_chat_test"]
  :prod ->
    config :firebrick, [db_url: "ecto://postgres_username:password@localhost/mogo_chat_production"]
  _ ->
    config :firebrick, [db_url: "ecto://postgres_username:password@localhost/mogo_chat_development"]
end

config :bcrypt, [mechanism: :port, pool_size: 4]

use Mix.Config

config :bcrypt, [mechanism: :port, pool_size: 4]

config :phoenix, MogoChat.Router,
  port: System.get_env("PORT"),
  ssl: false,
  code_reload: false,
  static_assets: true,
  cookies: true,
  session_key: "_mogo_chat_key",
  session_secret: (:crypto.strong_rand_bytes(64) |> :base64.encode_to_string |> to_string),
  consider_all_requests_local: true

config :phoenix, :logger, level: :error

case Mix.env do
  :test ->
    config :firebrick, [db_url: "ecto://postgres_username:password@localhost/mogo_chat_test"]
  :prod ->
    config :firebrick, [db_url: "ecto://postgres_username:password@localhost/mogo_chat_production"]
  _ ->
    config :firebrick, [db_url: "ecto://postgres_username:password@localhost/mogo_chat_development"]
end

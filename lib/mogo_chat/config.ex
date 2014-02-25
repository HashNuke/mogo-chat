# Production
defmodule MogoChat.Config do
  use Phoenix.Config.App

  config :router, port: 4000
  config :plugs, code_reload: false
end

# Development
defmodule MogoChat.Config.Dev do
  use MogoChat.Config

  config :router, port: System.get_env("PORT") || "4000"
  config :plugs, code_reload: true
  config :logger, level: :error
end

# Test
defmodule MogoChat.Config.Test do
  use MogoChat.Config

  config :router, port: 8888
  config :plugs, code_reload: true
  config :logger, level: :debug
end
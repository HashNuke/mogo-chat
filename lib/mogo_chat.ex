defmodule MogoChat do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    :ets.new :plug_sessions, [:named_table, :public, {:read_concurrency, true}]

    start_server = case :application.get_env(:mogo_chat, :start_server) do
      {:ok, value} -> value
      _ -> false
    end

    MogoChat.Supervisor.start_link([start_server: start_server])
  end

end

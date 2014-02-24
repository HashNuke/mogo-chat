defmodule MogoChat do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    :ets.new :plug_sessions, [:named_table, :public, {:read_concurrency, true}]
    MogoChat.Supervisor.start_link
  end
end

defmodule MogoChat.Supervisor do
  use Supervisor.Behaviour

  def start_link(options \\ [start_server: false]) do
    :supervisor.start_link(__MODULE__, options)
  end

  def init(options) do
    if options[:start_server] do
      children = [
        worker(MogoChat.Router, []),
        worker(Repo, [])
      ]
    else
      children = [ worker(Repo, []) ]
    end

    # See http://elixir-lang.org/docs/stable/Supervisor.Behaviour.html
    # for other strategies and supported options
    supervise(children, strategy: :one_for_one)
  end
end

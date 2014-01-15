defmodule Angel.IrcSupervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end


  def init([]) do
    children = [
      worker(Angel.IrcHandler, [], restart: :transient)
    ]

    supervise(children, strategy: :one_for_one, restart: :transient)
  end
end

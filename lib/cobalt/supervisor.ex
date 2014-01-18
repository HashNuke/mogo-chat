defmodule Cobalt.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link({ :local, __MODULE__ }, __MODULE__, [])
  end


  def init([]) do
    dynamo_options = [max_restarts: 5, max_seconds: 5]

    tree = [
      worker(Cobalt.Dynamo, [dynamo_options]),
      worker(Repo, [])
    ]

    supervise(tree, strategy: :one_for_all)
  end
end
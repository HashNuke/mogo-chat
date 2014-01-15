defmodule Angel.DynamoSupervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end


  def init([]) do
    dynamo_options = [max_restarts: 5, max_seconds: 5]

    children = [
      worker(Angel.Dynamo, [dynamo_options], restart: :transient)
    ]

    :ets.new(:angel_sessions, [:named_table, :public, {:read_concurrency, true}])

    supervise(children, strategy: :one_for_one, restart: :transient)
  end
end

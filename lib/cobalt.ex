defmodule Cobalt do
  use Application.Behaviour

  @doc """
  The application callback used to start this
  application and its Dynamos.
  """
  def start(_type, _args) do
    :ets.new(:cobalt_sessions, [:named_table, :public, {:read_concurrency, true}])
    Cobalt.Dynamo.start_link([max_restarts: 5, max_seconds: 5])
  end
end

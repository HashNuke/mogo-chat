defmodule Cobalt do
  use Application.Behaviour

  @doc """
  The application callback used to start this
  application and its Dynamos.
  """
  def start(_type, _args) do
    :ets.new(:cobalt_sessions, [:named_table, :public, {:read_concurrency, true}])
    Cobalt.Supervisor.start_link()
  end
end

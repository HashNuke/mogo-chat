defmodule Plugs.Session.Adapters.Ets do
  @behaviour Plugs.Session.Adapter

  @table :plug_sessions
  @max_tries 5000

  def init(opts), do: opts

  def get(sid) do
    case :ets.lookup(@table, sid) do
      [{_, data}] ->
        data
      _ ->
        nil
    end
  end


  def put(sid, data, tries \\ 0) when tries < @max_tries do
    # check_table
    if :ets.insert(@table, {sid, data}) do
      :ok
    else
      put sid, data, tries + 1
    end
  end
  def put(sid, _data ,tries) do
    {:error, "Unable to save data for '#{sid}' after #{tries} attempts."}
  end


  def delete(sid) do
    :ets.delete(@table, sid)
  end


  defp check_table do
    case :ets.info @table do
      :undefined ->
        :ets.new @table, [:named_table, :public, {:read_concurrency, true}]
      _ -> :ok
    end
  end
end
defmodule Wilcog.Server do
  use GenServer.Behaviour

  def init(_) do
    { :ok, HashDict.new }
  end

  def handle_call({:watch, group_name, asset_path}, _from, state) do
    { :reply, :ok, state }
  end

  def handle_cast({ :push, new }, state) do
    { :noreply, [new|state] }
  end
end
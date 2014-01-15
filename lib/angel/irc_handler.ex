defmodule Angel.IrcHandler do
  use GenServer.Behaviour

  defrecord State, data: nil

  def start_link do
    :gen_server.start_link({:local, __MODULE__}, __MODULE__, [], [])
  end

  def init([]) do
    {:ok, State.new}
  end

  def handle_call(_request, _from, state) do
    {:reply, :ignored, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  def handle_info({:incoming_message, from, incoming_message}, state) do
    :io.format("Incoming message: ~p ~p ~n", [incoming_message, from])
    {:noreply, state}
  end

  def handle_info(_info, state) do
    {:noreply, state}
  end

  def terminate(_reason, _state) do
    :ok
  end

  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end
end
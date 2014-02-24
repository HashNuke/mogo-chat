defmodule MogoChat.Util do

  defexception BadRequest, [:message] do
    defimpl Plug.Exception do
      def status(_exception) do
        400
      end
    end
  end


  @doc """
  Borrowed from ericmj's hex_web https://github.com/ericmj/hex_web/blob/master/lib/hex_web/util.ex#L43-L56
  Read the body from a Plug connection.

  Should be in Plug proper eventually and can be removed at that point.
  """
  def read_body({ :ok, buffer, state }, acc, limit, adapter) when limit >= 0,
    do: read_body(adapter.stream_req_body(state, 1_000_000), acc <> buffer, limit - byte_size(buffer), adapter)
  def read_body({ :ok, _, state }, _acc, _limit, _adapter),
    do: { :too_large, state }

  def read_body({ :done, state }, acc, limit, _adapter) when limit >= 0,
    do: { :ok, acc, state }
  def read_body({ :done, state }, _acc, _limit, _adapter),
    do: { :too_large, state }

end
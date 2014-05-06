#NOTE Borrowed from ericmj's hex_web project
defmodule MogoChat.JsonParser do
  alias Plug.Conn

  def parse(%Conn{} = conn, "application", "json", _headers, opts) do
    read_body(conn, Keyword.fetch!(opts, :limit))
  end

  def parse(conn, _type, _subtype, _headers, _opts) do
    { :next, conn }
  end


  defp read_body(conn, limit) do
    case HexWeb.Plug.read_body(conn, limit) do
      { :too_large, conn } ->
        { :too_large, conn }
      { :ok, "", conn } ->
        { :ok, [], conn }
      { :ok, body, conn } ->
        case JSEX.decode(body) do
          { :ok, params } ->
            { :ok, params, conn }
          _ ->
            raise MogoChat.Util.BadRequest, message: "malformed JSON"
        end
    end
  end

end
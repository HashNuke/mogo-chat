defmodule MogoChat.Errors do

  defmodule Unauthorized do
    defexception [:message]
    defimpl Plug.Exception do
      def status(_exception), do: 401
    end
  end

end

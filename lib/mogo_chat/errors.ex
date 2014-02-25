defmodule MogoChat.Errors do

  defexception Unauthorized, [:message] do
    defimpl Plug.Exception do
      def status(_exception) do
        401
      end
    end
  end

end
defmodule Plugs.Session.Adapter do
  @moduledoc """
  Specification of the session adapter API implemented 
  by adapters.
  """
  use Behaviour

  @type opts   :: Keyword.t
  @type sid    :: binary
  @type data   :: iodata
  @type reason :: String.t

  @doc """
  Defines a handler for starup logic.
  """
  defcallback init(opts) :: opts

  @doc """
  Defines ability to get `data` about the session for
  a particular session id (`sid`).
  """
  defcallback get(sid) :: {:ok, data} | {:error, reason}

  @doc """
  Defines ability to put `data` about the session for
  a particular session id (`sid`).
  """
  defcallback put(sid, data) :: :ok | {:error, reason}
end
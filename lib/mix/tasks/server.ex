defmodule Mix.Tasks.Server do
  use Mix.Task

  @shortdoc "Start server"

  @moduledoc """
  Server task.
  """
  def run(_) do
    :application.set_env(:mogo_chat, :start_server, true)
    :application.ensure_all_started(:mogo_chat)
  end
end

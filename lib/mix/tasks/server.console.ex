defmodule Mix.Tasks.Server.Console do
  use Mix.Task

  @shortdoc "Start server with console"

  @moduledoc """
  Server with console task.
  """
  def run(_) do
    :application.ensure_all_started(:mogo_chat)
    MogoChat.Router.start
    IEx.start
    :timer.sleep(:infinity)
  end
end

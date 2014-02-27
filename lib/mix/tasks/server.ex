defmodule Mix.Tasks.Server do
  use Mix.Task

  @shortdoc "Start server"

  @moduledoc """
  Server task.
  """
  def run(_) do
    :application.ensure_all_started(:mogo_chat)
    MogoChat.Router.start
  end
end

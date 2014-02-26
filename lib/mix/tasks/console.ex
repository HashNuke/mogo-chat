defmodule Mix.Tasks.Console do
  use Mix.Task

  @shortdoc "Start console only"

  @moduledoc """
  Console task.
  """
  def run(_) do
    :application.ensure_all_started(:mogo_chat)
    IEx.start
    :timer.sleep(:infinity)
  end
end

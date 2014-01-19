Dynamo.under_test(Cobalt.Dynamo)
Dynamo.Loader.enable
ExUnit.start
Hound.start [driver: "phantomjs"]

defmodule Cobalt.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end


defmodule TestUtils do
  def app(path) do
    "http://localhost:#{Cobalt.Dynamo.config[:server][:port]}/#{path}"
  end


  def truncate_db_after_test do
    table_names = ["users", "messages", "rooms"]
    sql = "TRUNCATE TABLE #{Enum.join(table_names, ", ")} RESTART IDENTITY CASCADE;"
    Repo.adapter.query(Repo, sql)
  end
end
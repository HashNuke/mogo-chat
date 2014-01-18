Dynamo.under_test(Cobalt.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule Cobalt.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end

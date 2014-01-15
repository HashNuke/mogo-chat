Dynamo.under_test(Angel.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule Angel.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end

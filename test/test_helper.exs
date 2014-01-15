Dynamo.under_test(Hym.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule Hym.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end

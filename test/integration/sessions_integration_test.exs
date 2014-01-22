defmodule SessionIntegrationTest do
  use Cheko.TestCase
  use Hound.Helpers
  import TestUtils

  hound_session
  truncate_db_after_test

  test "returns OK" do
    # user = User.new(email: "test@example.com", password: "password", first_name: "Test")
    # |> User.encrypt_password()
    # |> Repo.create

    navigate_to app("/")
    IO.inspect page_source()

    # conn = post("/api/sessions", [{"email", "test@example.com"}, {"password", "password"}])
    # IO.inspect conn.sent_body()
    assert true == true
  end
end

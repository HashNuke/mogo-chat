defmodule SessionIntegrationTest do
  use MogoChat.TestCase
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


  test "member should be able to login and logout" do
  end

  test "admin should be able to login and logout" do
  end

end

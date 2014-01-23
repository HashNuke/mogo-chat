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


  test "member should be able to login and logout" do
  end

  test "admin should be able to login and logout" do
  end


  ## User management

  test "admin should be able to view users" do
  end


  test "admin should be able to add users" do
  end


  test "admin should be able to remove users" do
  end


  test "admin should be able to edit users" do
  end


  test "admin should be able to update password for users" do
  end


  test "admin should *not* be able to remove self" do
  end


  test "member should be able to edit own account" do
  end


  test "member should be able to change own password" do
  end


  test "member should *not* be able to manage users" do
  end


  ## Room management

  test "admin should be able to view rooms" do
  end


  test "admin should be able to add rooms" do
  end


  test "admin should be able to remove rooms" do
  end


  test "admin should be able to edit rooms" do
  end


  test "member should *not* be able to manage rooms" do
  end


  test "admin should be able to go back to chat using navigation" do
  end


  ## Chat interface

  test "user should be able to join rooms" do
  end

  test "user should be able to leave rooms" do
  end

  test "user should be able to post message to active room" do
  end

  test "user should be able to switch rooms" do
  end

  test "user should receive messages when posted" do
  end

  test "should be able to load chat history of room" do
  end

  test "user should receive notification incase of mentions in inactive room" do
  end

  test "user should *not* receive notification if mentioned in active room" do
  end

  test "only active users in a room should be listed" do
  end
end

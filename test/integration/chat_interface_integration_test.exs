defmodule ChatInterfaceIntegrationTest do
  use MogoChat.TestCase
  use Hound.Helpers
  import TestUtils

  hound_session
  truncate_db_after_test


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


  test "when a user hasn't pinged for 5 seconds, mark as left" do
  end

end

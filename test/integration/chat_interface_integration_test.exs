defmodule ChatInterfaceIntegrationTest do
  use MogoChat.TestCase
  use Hound.Helpers
  import TestUtils

  hound_session
  truncate_db_after_test
  test_helpers


  test "user should be able to join rooms and leave rooms" do
    create_room("lobby")

    login_member("John", "john@example.com")
    join_room("lobby")
  end


  test "users should get each other's chat messages" do
    create_room("lobby")

    login_member("John", "john@example.com")
    join_room("lobby")

    in_browser_session :jane, fn->
      login_member("Jane", "jane@example.com")
      join_room("lobby")
    end

    new_msg = "Hi Jane"
    fill_field {:tag, "textarea"}, new_msg
    send_keys(:return)

    assert size(visible_text {:tag, "textarea"}) == 0

    in_browser_session :jane, fn->
      :timer.sleep(3000)
      msg = "Hi Jane"
      assert Regex.match?(%r/#{msg}/, page_source)

      fill_field {:tag, "textarea"}, "Hello John"
      send_keys(:return)
    end

    :timer.sleep(3000)
    assert Regex.match?(%r/(Hello John)/, page_source)

    messages = Repo.all Message
    assert length(messages) == 2
  end


  # test "user should be able to leave rooms" do
  # end


  # test "user should be able to post message to active room" do
  # end


  # test "user should be able to switch rooms" do
  # end


  # test "user should receive messages when posted" do
  # end


  # test "should be able to load chat history of room" do
  # end


  # test "user should receive notification incase of mentions in inactive room" do
  # end


  # test "user should *not* receive notification if mentioned in active room" do
  # end


  # test "only active users in a room should be listed" do
  # end


  # test "when a user hasn't pinged for 5 seconds, mark as left" do
  # end

end

defmodule SessionIntegrationTest do
  use MogoChat.TestCase
  use Hound.Helpers
  import TestUtils

  hound_session
  truncate_db_after_test
  wait_helpers

  test "should redirect to login if I visit a page without logging in" do
    navigate_to app_path()
    wait_until({:name, "login"})
    assert Regex.match?(%r/(login)/, current_url)
  end


  test "should show error when wrong password was entered" do
    user = create_member("Test", "test@example.com")

    navigate_to app_path()

    fill_field {:name, "email"}, user.email
    fill_field {:name, "password"}, "wrong password"
    click({:name, "login"})

    wait_until({:class, "error"})

    error_msg = visible_text({:class, "error"})
    assert Regex.match?(%r/(Please check your login credentials)/, error_msg)
  end


  test "should show error when the user does not have an account" do
    navigate_to app_path()

    fill_field {:name, "email"}, "nobody@example.com"
    fill_field {:name, "password"}, "password"
    click({:name, "login"})

    wait_until({:class, "error"})

    error_msg = visible_text({:class, "error"})
    assert Regex.match?(%r/(Maybe you don't have an account)/, error_msg)
  end


  test "member should be able to login and logout" do
    user = create_member("Test", "test@example.com")

    navigate_to app_path()
    wait_until({:name, "email"})
    url_at_login = current_url()

    fill_field {:name, "email"}, user.email
    fill_field {:name, "password"}, "password"
    click({:name, "login"})

    wait_until({:class, "left-panel-wrapper"})
    assert url_at_login != current_url()

    click({:id, "logout-btn"})
    assert url_at_login == current_url()
  end


  test "admin should be able to login and logout" do
    user = create_admin("Test", "test@example.com")

    navigate_to app_path()
    wait_until({:name, "email"})
    url_at_login = current_url()

    fill_field {:name, "email"}, user.email
    fill_field {:name, "password"}, "password"
    click({:name, "login"})

    wait_until({:class, "left-panel-wrapper"})
    assert url_at_login != current_url()

    click({:id, "logout-btn"})
    wait_until({:name, "login"})

    IO.inspect current_url()

    assert url_at_login == current_url()
  end

end

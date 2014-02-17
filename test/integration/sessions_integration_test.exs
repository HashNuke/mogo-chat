defmodule SessionIntegrationTest do
  use MogoChat.TestCase
  use Hound.Helpers
  import TestUtils

  hound_session
  truncate_db_after_test


  def wait_until(element, func \\ nil) do
    if until_element(element) do
      if func do
        apply(func, [])
      else
        true
      end
    else
      IO.inspect "The following element wasn't found:"
      throw element
    end
  end


  def until_element(element, wait_time \\ 10) do
    new_wait_time = wait_time - 1
    :timer.sleep(1000)
    {strategy, identifier} = element

    if new_wait_time > 0 do
      try do
        find_element(strategy, identifier)
      catch
        _ ->
          until_element(element, new_wait_time)
      else
        _ ->
          true
      end
    else
      find_element(strategy, identifier)
    end
  end


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
    url_at_login = current_url()

    fill_field {:name, "email"}, user.email
    fill_field {:name, "password"}, "password"
    click({:name, "login"})

    wait_until({:class, "left-panel-wrapper"})
    assert url_at_login != current_url()

    click({:id, "logout-btn"})
    assert url_at_login == current_url()
  end

end

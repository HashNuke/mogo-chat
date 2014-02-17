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


  def until_element(element, wait_time \\ 10000) do
    new_wait_time = wait_time - 1000
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
    # navigate_to app_path()
    # current_url = 
    # Regex.match?(%r/(login)/, app_path())
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

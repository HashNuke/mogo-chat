defmodule UserManagementIntegrationTest do
  use Mogo.TestCase
  use Hound.Helpers
  import TestUtils

  hound_session
  truncate_db_after_test


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
end

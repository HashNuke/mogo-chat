defmodule SessionTest do
  use Mogo.TestCase
  use Dynamo.HTTP.Case
  import TestUtils

  #TODO
  # can't write these tests because Dynamo's Test connection doesn't parse
  # request body, so params aren't set for connection

  # truncate_db_after_test
  #
  # test_dynamo(Mogo.Dynamo)
  # @endpoint Mogo.Dynamo
  #
  # test "should return user details after successful login" do
  #   user = User.new(first_name: "Test", email: "test@example.com", password: "password")
  #   user = User.encrypt_password(user)
  #   Repo.create(user)
  #
  #   conn = post("/api/sessions", [{"email", "test@example.com"}, {"password", "password"}])
  #   IO.inspect conn.sent_body
  #
  #   assert true
  # end

end

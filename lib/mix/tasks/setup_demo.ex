defmodule Mix.Tasks.Setup.Demo do
  use Mix.Task

  @shortdoc "Create demo user and 2 example rooms after truncating the tables"

  @moduledoc """
  Truncates db and creates demo user and Lobby room.
  """
  def run(_) do
    :application.ensure_all_started(:mogo_chat)

    # Truncate everything
    table_names = ["users", "messages", "rooms", "room_user_states"]
    sql = "TRUNCATE TABLE #{Enum.join(table_names, ", ")} RESTART IDENTITY CASCADE;"
    Repo.adapter.query(Repo, sql, [])


    demo_user = User.new(
        email: "demo@example.com",
        password: "password",
        name: "Demo",
        role: "member",
        archived: false)
    |> User.encrypt_password()
    |> User.assign_auth_token()

    case User.validate(demo_user) do
      [] ->
        _saved_user = Repo.create(demo_user)
      errors ->
        IO.puts "Error while creating demo user..."
        IO.puts errors
    end

    lobby = Room.new(name: "Lobby")
    case Room.validate(lobby) do
      [] ->
        _saved_room = Repo.create(lobby)
      errors ->
        IO.puts "Error while creating first room..."
        IO.puts errors
    end


    another_room = Room.new(name: "Project Talk")
    case Room.validate(another_room) do
      [] ->
        _saved_room = Repo.create(another_room)
      errors ->
        IO.puts "Error while creating second room"
        IO.puts errors
    end
  end
end

# Cheko


## Usage

You'll need Erlang version R16B02 or higher, Elixir version v0.12.2 and Postgresql.

* Create a postgres database called `cheko_development`

* Get the dependencies: `mix deps.get`

* Run migrations on the database: `mix ecto.migrate`

* Setup the app with an admin user: `mix setup`

* Start the app: `iex --erl "-config cheko.config" -S mix server`


## Development

* Run `bundle exec rake assets:watch` to start asset server.


## Tests

For running test, you'll need a database called `cheko_test`.

* Get dependencies: `MIX_ENV=test mix deps.get`


# MogoChat


## Usage

You'll need Erlang version R16B02 or higher, Elixir version v0.12.4 and Postgresql.

* Create a postgres database called `mogo_chat_development`

* Then copy-paste the following into your terminal:

```
mix deps.get
bash scripts/migrate
bash scripts/setup
```

## Start the app

```
bash scripts/start
```

## Development

* Run `bundle exec rake assets:watch` to start asset server.

* To start the app with an iex shell, run `bash scripts/start_with_shell`

## Tests

For running test, you'll need a database called `mogo_chat_test`.

* Get dependencies: `MIX_ENV=test mix deps.get`

* Run tests: `mix test`

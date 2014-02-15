# Install instructions for different platforms

### Heroku

You'll need a [Heroku](http://heroku.com) account and the [Heroku Toolbelt](https://toolbelt.heroku.com/).

Once you have them, copy-paste these commands in your terminal

```
git clone https://github.com/HashNuke/mogo-chat.git
cd mogo-chat
heroku create --buildpack "https://github.com/HashNuke/heroku-elixir-buildpack.git"
git push heroku master
heroku run bash scripts/migrate
heroku run bash scripts/setup
heroku apps:info
```

The last command will output your Heroku app's URL. Enjoy ~!

---

### Local install for development and other purposes

You'll need Erlang version R16B02 or higher, Elixir version v0.12.4 and Postgresql.

* Create a postgresql database called `mogo_chat_development`

* Copy the `config/database.json.sample` as `config/database.json` and edit the database credentials.

* Then copy-paste the following into your terminal:

```
mix deps.get
bash scripts/migrate
bash scripts/setup
```

Use one of the following commands to start the app:

```
# you can start server with an Elixir console
bash scripts/start_with_shell

# Or you can start without the console
bash scripts/start
```

#### Building assets

You'll need Ruby for this. Install a nice version like Ruby 2.1 and install the `bundler` and `rake` rubygems. Then run `bundle install` to install Ruby dependencies. When done, you will be able to use the following commands to compile or watch assets when development is happening.

* Run `bundle exec rake assets:compile` to compile assets once.

* Run `bundle exec rake assets:watch` to start asset server.

To compress javascript when building assets, use the env var `MIX_ENV=prod`.

#### Tests

For running test, you'll need a database called `mogo_chat_test`. Make sure you also edit the credentials in `config/database.json` as required.

* Get dependencies: `MIX_ENV=test mix deps.get`

* Run tests: `bash scripts/run_tests`


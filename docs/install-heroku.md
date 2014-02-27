# Heroku install instructions

You'll need a [Heroku](http://heroku.com) account and the [Heroku Toolbelt](https://toolbelt.heroku.com/).

Once you have them, copy-paste the following commands in your terminal.

__Don't copy-paste one by one. It's tedious. Just copy all the commands at once and paste it.__

```
git clone https://github.com/HashNuke/mogo-chat.git
cd mogo-chat
heroku create --buildpack "https://github.com/HashNuke/heroku-elixir-buildpack.git"
git push heroku master
heroku run bash scripts/migrate && heroku run bash scripts/setup && heroku apps:info
```

The last command will output your Heroku app's URL. Enjoy ~!

Visit the app and use `admin@example.com` as your login email and the password is `password`.

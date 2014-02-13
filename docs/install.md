## Install instructions for different platforms

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

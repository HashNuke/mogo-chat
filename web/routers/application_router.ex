defmodule ApplicationRouter do
  use Dynamo.Router

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch([:cookies, :session, :headers, :params, :body]).assign(:layout, "application")
  end

  # It is common to break your Dynamo into many
  # routers, forwarding the requests between them:
  # forward "/posts", to: PostsRouter


  forward "/api/sessions", to: SessionsApiRouter
  # forward "/api/channels", to: ChannelsApiRouter
  # forward "/api/users",    to: UsersApiRouter
  # forward "/api/threads",  to: ThreadsApiRouter
  # forward "/api/mails",    to: MailsApiRouter


  get "/" do
    conn = conn.assign(:title, "Welcome to Dynamo!")
    render conn, "index.html"
  end
end

defmodule Angel.Dynamo do
  use Dynamo

  config :dynamo,
    # The environment this Dynamo runs on
    env: Mix.env,

    # The OTP application associated with this Dynamo
    otp_app: :angel,

    # The endpoint to dispatch requests to
    endpoint: ApplicationRouter,

    # The route from which static assets are served
    # You can turn off static assets by setting it to false
    static_route: "/static"

  # config :dynamo,
  #   session_store: Session.CookieStore,
  #   session_options:
  #     [ key: "_angel_session",
  #       secret: "dPFxY9JxtCRtXUpWOEd0+YRIUwlnG4tcuYbUza5AIKXxhFhiCAyR4NYCDD1C5YLt"]

  config :dynamo,
    session_store: Session.ETSStore,
    session_options: [
      table: :angel_sessions,
      key: "_angel_session"
    ]

  # Default functionality available in templates
  templates do
    use Dynamo.Helpers
  end
end

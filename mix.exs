defmodule MogoChat.Mixfile do
  use Mix.Project

  def project do
    [ app: :mogo_chat,
      version: "0.0.1",
      build_per_environment: true,
      dynamos: [MogoChat.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      deps: deps(Mix.env) ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo, :bcrypt, :qdate, :jsex, :uuid],
      mod: { MogoChat, [] } ]
  end

  defp deps(:prod) do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, "~> 0.1.0-dev", github: "fishcakez/dynamo", branch: "sendfile" },
      { :postgrex, github: "ericmj/postgrex" },
      { :ecto, github: "elixir-lang/ecto" },
      { :jsex, github: "talentdeficit/jsex" },
      { :qdate, github: "choptastic/qdate" },
      { :bcrypt, github: "irccloud/erlang-bcrypt" },
      { :uuid, github: "okeuday/uuid" }
    ]
  end

  defp deps(_) do
    deps(:prod) ++ [{ :hound, github: "HashNuke/hound" }]
  end
end

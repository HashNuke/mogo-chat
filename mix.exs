defmodule Cobalt.Mixfile do
  use Mix.Project

  def project do
    [ app: :cobalt,
      version: "0.0.1",
      build_per_environment: true,
      dynamos: [Cobalt.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo, :bcrypt],
      mod: { Cobalt, [] } ]
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, "~> 0.1.0-dev", github: "elixir-lang/dynamo" },
      { :postgrex, github: "ericmj/postgrex" },
      { :ecto, github: "elixir-lang/ecto" },
      { :jsex,    github: "talentdeficit/jsex" },
      { :bcrypt, github: "irccloud/erlang-bcrypt" }
    ]
  end
end

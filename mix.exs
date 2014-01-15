defmodule Angel.Mixfile do
  use Mix.Project

  def project do
    [ app: :angel,
      version: "0.0.1",
      build_per_environment: true,
      dynamos: [Angel.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo],
      mod: { Angel, [] } ]
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, "~> 0.1.0-dev", github: "elixir-lang/dynamo" },
      { :postgrex, github: "ericmj/postgrex" },
      { :ecto, github: "elixir-lang/ecto" },
      { :irc_lib, github: "0xAX/irc_lib" }
    ]
  end
end

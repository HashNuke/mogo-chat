defmodule MogoChat.Mixfile do
  use Mix.Project

  def project do
    [ app: :mogo_chat,
      version: "0.0.1",
      build_per_environment: true,
      elixir: "~> 0.12.4",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      applications: [:erlydtl, :bcrypt, :qdate, :jsex, :uuid],
      mod: { MogoChat, []}
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
      {:phoenix, github: "phoenixframework/phoenix"},
      {:erlydtl, github: "erlydtl/erlydtl", tag: "0.9.0"},
      {:ecto, github: "elixir-lang/ecto"},
      {:postgrex, github: "ericmj/postgrex"},
      {:jsex, github: "talentdeficit/jsex"},
      {:qdate, github: "choptastic/qdate" },
      {:bcrypt, github: "irccloud/erlang-bcrypt"},
      {:uuid, github: "okeuday/uuid"}
    ]
  end
end

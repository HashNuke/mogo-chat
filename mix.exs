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
      applications: [:phoenix, :erlydtl, :bcrypt, :qdate, :jsex, :uuid],
      mod: { MogoChat, []}
    ]
  end


  defp deps do
    [
      # {:phoenix,  github: "phoenixframework/phoenix"},
      {:phoenix,  path: "/Users/akashmanohar/projects/phoenix"},
      {:erlydtl,  github: "erlydtl/erlydtl", tag: "0.9.0"},
      {:ecto,     github: "elixir-lang/ecto"},
      {:postgrex, github: "ericmj/postgrex"},
      {:jsex,     github: "talentdeficit/jsex"},
      {:qdate,    github: "choptastic/qdate" },
      {:bcrypt,   github: "irccloud/erlang-bcrypt"},
      {:uuid,     github: "okeuday/uuid"}
    ]
  end
end

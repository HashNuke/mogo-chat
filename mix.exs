defmodule MogoChat.Mixfile do
  use Mix.Project

  def project do
    [ app: :mogo_chat,
      version: "0.0.1",
      build_per_environment: true,
      elixir: "~> 0.13.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      applications: [:phoenix, :bcrypt, :qdate, :jsex, :uuid],
      mod: { MogoChat, []}
    ]
  end


  defp deps do
    [
      {:cowboy,   github: "extend/cowboy"},
      {:phoenix,  github: "phoenixframework/phoenix"},
      {:ecto,     "~> 0.1.0" },
      {:postgrex, "~> 0.5.0" },
      {:jsex,     github: "talentdeficit/jsex", branch: "develop"},
      {:qdate,    github: "choptastic/qdate" },
      {:bcrypt,   github: "irccloud/erlang-bcrypt"},
      {:uuid,     github: "okeuday/uuid"}
    ]
  end
end

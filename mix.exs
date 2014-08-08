defmodule MogoChat.Mixfile do
  use Mix.Project

  def project do
    [ app: :mogo_chat,
      version: "0.0.1",
      build_per_environment: true,
      elixir: "~> 0.15.0",
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
      {:cowboy,   "~> 1.0.0"},
      {:phoenix,  github: "phoenixframework/phoenix"},
      {:ecto,     "~> 0.2.3" },
      {:postgrex, "~> 0.5.0" },
      {:qdate,    github: "choptastic/qdate" },
      {:bcrypt,   github: "irccloud/erlang-bcrypt"},
      {:uuid,     github: "okeuday/uuid"}
    ]
  end
end

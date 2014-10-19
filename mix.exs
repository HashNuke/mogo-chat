defmodule MogoChat.Mixfile do
  use Mix.Project

  def project do
    [ app: :mogo_chat,
      version: "0.2",
      build_per_environment: true,
      elixir: "~> 1.0.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      applications: [:phoenix, :bcrypt, :qdate, :uuid],
      mod: { MogoChat, []}
    ]
  end


  defp deps do
    [
      {:cowboy,   "~> 1.0.0"},
      {:phoenix,  "~> 0.5.0"},
      {:ecto,     "~> 0.2.5"},
      {:postgrex, "~> 0.6.0"},
      {:qdate,    github: "choptastic/qdate" },
      {:bcrypt,   github: "irccloud/erlang-bcrypt"},
      {:uuid,     github: "okeuday/uuid"}
    ]
  end
end

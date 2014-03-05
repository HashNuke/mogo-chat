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
      applications: [:phoenix, :bcrypt, :qdate, :jsex, :uuid],
      mod: { MogoChat, []}
    ]
  end


  defp deps do
    [
      {:stylish,  github: "hashnuke/stylish", submodules: true, override: true},
      {:phoenix,  github: "phoenixframework/phoenix"},
      {:ecto,     github: "elixir-lang/ecto"},
      {:postgrex, github: "ericmj/postgrex"},
      {:jsex,     github: "talentdeficit/jsex"},
      {:qdate,    github: "choptastic/qdate" },
      {:bcrypt,   github: "irccloud/erlang-bcrypt"},
      {:uuid,     github: "okeuday/uuid"}
    ]
  end
end

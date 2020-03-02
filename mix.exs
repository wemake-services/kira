defmodule Kira.MixProject do
  use Mix.Project

  def project do
    [
      app: :kira,
      version: "0.1.0",
      elixir: "~> 1.8.2",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.travis": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Kira.Application, []},
      extra_applications: [:logger, :runtime_tools, :ueberauth_gitlab_strategy]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Default phoenix:
      {:phoenix, "~> 1.4.1"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:cowboy, "~> 2.5", override: true},

      # Custom dependencies:
      {:exop, "~> 1.2.3"},
      {:tesla, "~> 1.2.0"},
      {:hackney, "~> 1.15.1"},
      {:quantum, "~> 2.3"},
      {:timex, "~> 3.0"},
      {:ueberauth_gitlab_strategy, "~> 0.2"},
      # need for oauth2 serialization https://github.com/ueberauth/ueberauth_github/issues/43 (gitlab haves the same),
      # remove after update lib
      {:poison, "~> 4.0"},

      # Dev only:
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:exsync, "~> 0.2", only: :dev},

      # Tests:
      {:excoveralls, "~> 0.10", only: :test},
      {:ex_machina, "~> 2.3", only: :test},
      {:faker, "~> 0.12", only: :test},
      {:mox, "~> 0.5", only: :test},
      {:sobelow, "~> 0.7", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.2.3", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end

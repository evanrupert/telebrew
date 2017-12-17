defmodule TelegramBotWrapper.Mixfile do
  use Mix.Project

  def project do
    [
      app: :telegram_bot_wrapper,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:httpoison, "~> 0.13.0"},
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.18.1"},
      {:earmark, "~> 1.2"}
    ]
  end
end

# TODO: implement all methods in the telegram bot api

# TODO: implement polling for the getUpdates method

# TODO: implement validation for matches

# TODO: return message text without command in it

# TODO: test repeat match declarations and stuff like that and then implement validation for that

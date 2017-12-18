defmodule Telebrew.Mixfile do
  use Mix.Project

  def project do
    [
      app: :telebrew,
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
      {:httpoison, "~> 0.13.0"},
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.18.1"},
      {:earmark, "~> 1.2"}
    ]
  end
end

# TODO: start each listener evaluation in its own process as to not interfere with other listeners

# TODO: write github readme with install, config, and getting started instructions

# TODO: implement all methods in the telegram bot api

# TODO: create when guards for further pattern matching
# EXAMPLE
# on "text", when: String.length(m.text) == 40 do
#   send_message m.chat.id, "The character length is 40"
# end

# TODO: test repeat match declarations and stuff like that and then implement validation for that

# TODO: write documentation for all functions

# TODO: maybe add helper functions that will get the last n messages or something

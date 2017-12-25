defmodule Telebrew.Mixfile do
  use Mix.Project

  def project do
    [
      app: :telebrew,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
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

# TODO: write github readme with install, config, and getting started instructions

# TODO: implement all methods in the telegram bot api

# TODO: implement when guard by just translating that to the func def
# when guard in the generated code

# TODO: test repeat match declarations and stuff like that and then implement validation for that

# TODO: write documentation for all functions

# TODO: maybe add helper functions that will get the last n messages or something

# TODO: write simple response macro without the need of m.chat.id
# for message sending
# Example
# on "photo" do
#   respond "Received photo"
# end

# TODO: do some process supervison thing to restart the process
# that keeps timing out
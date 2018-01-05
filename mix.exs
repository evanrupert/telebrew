defmodule Telebrew.Mixfile do
  use Mix.Project

  @description """
  Simple wrapper for the telegram bot api.
  """

  def project do
    [
      app: :telebrew,
      version: "0.1.0",
      elixir: "~> 1.5",
      description: @description,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:httpoison]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.13.0"},
      {:poison, "~> 3.1"},
      {:ex_doc, "~> 0.18.1", only: :dev},
      {:earmark, "~> 1.2", only: :dev}
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs LICENCE)
      maintainers: ["Evan Rupert"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/evanrupert/telebrew"}
    ]
  end
end

# TODO: write github readme with install, config, and getting started instructions

# TODO: implement all methods in the telegram bot api

# TODO: implement when guard by using macros to define a new guard function
# and then use that function in the when guard for the generated function

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

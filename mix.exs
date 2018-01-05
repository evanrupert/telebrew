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

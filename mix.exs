defmodule Telebrew.Mixfile do
  use Mix.Project

  @description """
  Simple framework for the telegram bot api.
  """

  def project do
    [
      app: :telebrew,
      version: "0.1.0",
      elixir: "~> 1.5",
      description: @description,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 0.13.0"},
      {:poison, "~> 3.1"},
      {:nadia, "~> 0.4.3"},
      {:ex_doc, "~> 0.18.1", only: :dev},
      {:earmark, "~> 1.2", only: :dev},
      {:excoveralls, "~> 0.8.0", only: :test},
      {:credo, "~> 0.9.2", only: :dev}
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs LICENCE),
      maintainers: ["Evan Rupert"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/evanrupert/telebrew"}
    ]
  end
end

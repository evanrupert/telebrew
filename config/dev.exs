use Mix.Config

config :telebrew,
  api_key: System.get_env("TELEGRAM_API_KEY"),
  polling_interval: 500

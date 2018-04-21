use Mix.Config

config :telebrew, api_key: System.get_env("TELEGRAM_API_KEY")

config :nadia, token: System.get_env("TELEGRAM_API_KEY")

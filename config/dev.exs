use Mix.Config

config :telebrew,
  api_key: System.get_env("TELEGRAM_API_KEY")

config :telebrew,
  telegram_wrapper: Nadia

config :nadia,
  token: System.get_env("TELEGRAM_API_KEY")

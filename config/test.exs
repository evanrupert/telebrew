use Mix.Config

# config :telebrew, api_key: System.get_env("TELEGRAM_API_KEY")

# config :nadia, token: System.get_env("TELEGRAM_API_KEY")

config :telebrew,
  telegram_wrapper: Telebrew.Test.MockWrapper

config :telebrew,
  quiet: true

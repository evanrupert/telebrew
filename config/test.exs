use Mix.Config

config :nadia, token: System.get_env("TELEGRAM_API_KEY")

config :telebrew,
  quiet: true,
  listener_module: Testing,
  telegram_wrapper: Telebrew.Test.MockWrapper

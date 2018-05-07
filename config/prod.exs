use Mix.Config

config :telebrew,
  telegram_wrapper: Nadia

config :nadia,
  token: Application.get_env(:telebrew, :api_key)

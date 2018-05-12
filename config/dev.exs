use Mix.Config

config :telebrew,
  telegram_wrapper: Nadia,
  quiet: false,
  listener_module: Testing,
  webhook_url: "https://telebrew-testing.herokuapp.com/"

config :nadia,
  token: System.get_env("TELEGRAM_API_KEY");


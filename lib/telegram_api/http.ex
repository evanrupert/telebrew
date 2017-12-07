defmodule TelegramApi.HTTP do
  @moduledoc """
  Module for low-level http requests to the telegram bot api
  """
  @url_base "https://api.telegram.org/bot"
  @api_key Application.get_env(:telegram_api, :api_key)


  def post(method, body) do
    json_body = Poison.encode! body

    headers = [{"Content-type", "application/json"}]

    resp = HTTPoison.post! "#{@url_base}#{@api_key}/#{method}", json_body, headers
    
    Poison.decode! resp.body
  end
end
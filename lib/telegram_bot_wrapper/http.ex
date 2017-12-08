defmodule TelegramBotWrapper.HTTP do
  @moduledoc """
  Module for low-level http requests to the telegram bot api
  """
  @url_base "https://api.telegram.org/bot"
  @api_key Application.get_env(:telegram_bot_wrapper, :api_key)


  def request(method, body) do
    json_body = Poison.encode! body

    headers = [{"Content-type", "application/json"}]

    response = HTTPoison.post "#{@url_base}#{@api_key}/#{method}", json_body, headers
    

    case response do
      { :ok, resp } -> 
        case Poison.decode! resp.body do
          %{"ok" => true, "result" => result } 
            -> { :ok, result }
          %{"ok" => false, "error_code" => code, "description" => des} 
            -> { :error, %{ "error_code" => code, "description" => des } }
        end
      x -> x  
    end

  end
end
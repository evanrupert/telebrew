defmodule TelegramBotWrapper.Methods do
  import TelegramBotWrapper.HTTP

  @docs_address "https://core.telegram.org/bots/api"

  @moduledoc """
  This module stores all of the abstractions over the telegram bot api methods
  """

  @doc """
  Sends a message to the given chat_id

  Returns {:ok, result} where result is the http response or {:error, reason} where reason is the error

  ## Optional Parameters ##
   
  | Name                     | Type    | Purpose                                                                                               |
  | ----                     | ----    | -------                                                                                               | 
  | parse_mode               | String  | Use "Markdown" or "HTML" to have telegram parse the message with that markup respectivly              |  
  | disable_web_page_preview | Boolean | Disables website preview if a link is in the message                                                  | 
  | disable_notification     | Boolean | Disables sound or vibration of the message                                                            |
  | reply_to_message_id      | Integer | If the message is a reply, ID of the original message                                                 |
  | reply_markup             | Map     | Additional interface options, see #{@docs_address} for more information about the type                |

  ## Example ##
      # will send the message "Hello" to the chat_id 123456789 without a notification
      send_message(123456789, "Hello", disable_notification: true)


  """
  def send_message(chat_id, message, params \\ []) do
    optional_params = [:parse_mode, :disable_web_page_preview, :disable_notification, :reply_to_message_id, :reply_markup]

    json_body = %{
                  chat_id: chat_id,
                  text: message
                } 
                |> add_optional_params(optional_params, params)

    request("sendMessage", json_body)
  
  end

  @doc """
  Returns basic information about the bot in the form of a User object
  """
  def get_me(), do: request("getMe", %{})


  @doc """
  Forward messages of any kind

  ## Optional Parameters ##
  
  | Name                 | Type    | Purpose                                  |
  | disable_notification | Boolean | Disables notification sound or vibration |
  """
  def forward_message(chat_id, from_chat_id, message_id, params \\ []) do

    json_body = %{
      chat_id: chat_id,
      from_chat_id: from_chat_id,
      message_id: message_id
    }
    |> add_optional_params([:disable_notification], params)

    request("forwardMessage", json_body)

  end


  defp add_optional_params(map, param_names, params) do
    # Enum.reduce over the list of optional parameters, if it is not nil add it to the parameter map
    param_names
    |> Enum.reduce(map, fn(name, acc) ->
      val = Keyword.get(params, name)
      if val != nil do Map.put(acc, name, val) else acc end
    end)
  end
end
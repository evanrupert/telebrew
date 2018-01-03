defmodule Telebrew.Methods do
  import Telebrew.HTTP

  @docs_address "https://core.telegram.org/bots/api"
  
  @moduledoc """
  This module stores all of the abstractions over the telegram bot api methods
  """

  @doc """
  Sends a message to the given chat_id

  Returns { :ok, result } where result is a [Message](#{@docs_address}#message) or { :error, reason }


  ## Optional Parameters ##

  - `parse_mode`: (String) Use "Markdown" or "HTML" to have telegram parse the message with the respective markdown style
  - `disable_web_page_preview`: (Boolean) Disables preview of webpages when a link is in the message
  - `disable_notification`: (Boolean) Disables sound or vibration of the message
  - `reply_to_message_id`: (Integer) If the message is a reply, ID of the original message
  - `reply_markup`: (Map) Additional interface options, go [here](#{@docs_address}#sendMessage) for more information about this option

  ## Example ##
      # will send the message "Hello" to the chat_id 123456789 without a notification
      send_message(123456789, "Hello", disable_notification: true)

  """
  def send_message(chat_id, message, params \\ []) do
    optional_params = [
      :parse_mode,
      :disable_web_page_preview,
      :disable_notification,
      :reply_to_message_id,
      :reply_markup
    ]

    json_body =
      %{
        chat_id: chat_id,
        text: message
      }
      |> add_optional_params(optional_params, params)

    request("sendMessage", json_body)
  end

  @doc """
  Same as `send_message/2` but will raise `Telebrew.Error` exception on failure
  """
  def send_message!(chat_id, message, params \\ []) do
    send_message(chat_id, message, params)
    |> check_error
  end

  @doc """
  Returns basic information about the bot in the form of a User object
  """
  def get_me(), do: request("getMe", %{})

  @doc """
  Same as `get_me/0` but will raise `Telebrew.Error` exception on failure
  """
  def get_me!(), do: request("getMe", %{}) |> check_error

  @doc """
  Forward messages of any kind

  ## Optional Parameters ##

  - `disable_notification`: (Boolean) Disables notification sound or vibration
  """
  def forward_message(chat_id, from_chat_id, message_id, params \\ []) do
    # TODO: test this somehow
    json_body =
      %{
        chat_id: chat_id,
        from_chat_id: from_chat_id,
        message_id: message_id
      }
      |> add_optional_params([:disable_notification], params)

    request("forwardMessage", json_body)
  end

  @doc """
  Same as `forward_message/3` but will raise `Telebrew.Error` on failure
  """
  def forward_message!(chat_id, from_chat, message_id, params \\ []) do
    forward_message(chat_id, from_chat, message_id, params)
    |> check_error
  end
  @doc """
  Sends a photo to the given chat_id

  ## Optional Parameters ##
    - `caption`: (String) Photo caption 0-200 characters
    - `disable_notification`: (Boolean) Sends message without sound or vibration
    - `reply_to_message_id`: (Integer) If the message is a reply, ID of the original message
    - `reply_markup`: (Map) Additional interface options go [here](#{@docs_address}#sendPhoto) for more info
  
  ## Example ##
      # will echo a photo back to the user with the caption "echo"
      on "photo" do
        photo = List.first m.photo
        send_photo m.chat.id, photo.file_id, caption: "echo"
      end
  """
  def send_photo(chat_id, photo, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        photo: photo
      }
      |> add_optional_params(
        [:caption, :disable_notification, :reply_to_message_id, :reply_markup],
        params
      )

    request("sendPhoto", json_body)
  end

  @doc """
  Same as `send_photo/2` but will raise `Telebrew.Error` on failure
  """
  def send_photo!(chat_id, photo, params \\ []) do
    send_photo(chat_id, photo, params)
    |> check_error
  end

  @doc """
  Sends an audio file to the given chat_id

  ## Optional Parameters ##
  - `caption`: (String) Caption for audio file, 0-200 characters
  - `duration`: (Integer) Duration of audio in seconds
  - `performer`: (String) Performer of audio
  - `title`: (String) Title of audio
  - `disable_notification`: (Boolean) Sends message without sound or vibration
  - `reply_to_message_id`: (Boolean) If message is a reply, ID of he original message
  - `reply_markup`: (Map) Additional interface options, go [here](#{@docs_address}#sendAudio) for more information
  """
  def send_audio(chat_id, audio, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        audio: audio
      }
      |> add_optional_params(
        [:caption, :duration, :performer, :title, :disable_notification,
         :reply_to_message_id, :reply_markup],
         params
      )

    request("sendAudio", json_body)
  end

  @doc """
  Same as `send_audio/2` but will raise `Telebrew.Error` on failure
  """
  def send_audio!(chat_id, audio, params \\ []) do
    send_audio(chat_id, audio, params)
    |> check_error
  end

  @doc """
  Sends general files up to 50 MB in size

  ## Optional Parameters ##
  - `caption`: (String) Document caption
  - `disable_notification`: (Boolean) Sends message without sound or vibration
  - `reply_to_message_id`: (Integer) If message is a reply, ID of he original message
  - `reply_markup`: (Map) Additional interface options, go [here](#{@docs_address}#sendAudio) for more information
  """
  def send_document(chat_id, document, params \\ []) do
    json_body = 
      %{
        chat_id: chat_id,
        document: document
      }
      |> add_optional_params(
        [:caption, :disable_notification, :reply_to_message_id,
         :reply_markup],
         params
      )

      request("sendDocument", json_body)
  end

  @doc """
  Same as `send_document/2` but will raise `Telebrew.Error` on failure
  """
  def send_document!(chat_id, document, params \\ []) do
    send_document(chat_id, document, params)
    |> check_error
  end

  @doc """
  Sends video files, supports mp4 videos (other formats will be sent as a Document)

  
  ## Optional Parameters ##
  - `duration`: (Integer) Duration of send video in seconds
  - `width`: (Integer) Video width
  - `height`: (Integer) Video height
  - `caption`: (String) Video caption 0-200 characters
  - `disable_notification`: (Boolean) Sends message without sound or vibration
  - `reply_to_message_id`: (Integer) If message is a reply, ID of he original message
  - `reply_markup`: (Map) Additional interface options, go [here](#{@docs_address}#sendAudio) for more information
  """
  def send_video(chat_id, video, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        video: video
      }
      |> add_optional_params(
        [:duration, :width, :height, :caption, :disable_notification,
         :reply_to_message_id, :reply_markup],
         params
      )

      request("sendVideo", json_body)
  end

  @doc """
  Same as `send_video/2` but will raise `Telebrew.Error` on failure
  """
  def send_video!(chat_id, video, params \\ []) do
    send_video(chat_id, video, params)
    |> check_error
  end

  @doc """
  Use to send audio files that the telegram client will display as a playable
  voice message

  The audio must be in an .ogg file encoded with OPUS and be no larger than 50 MB

  ## Optional Parameters ##
  - `caption`: (String) Voice message caption, 0-200 characters
  - `duration`: (Integer) Duration of voice message in seconds
  - `disable_notification`: (Boolean) Sends message without sound or vibration
  - `reply_to_message_id`: (Integer) If message is a reply, ID of he original message
  - `reply_markup`: (Map) Additional interface options, go [here](#{@docs_address}#sendAudio) for more information
  """
  def send_voice(chat_id, voice, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        voice: voice
      }
      |> add_optional_params(
        [:caption, :duration, :disable_notification,
         :reply_to_message_id, :reply_markup],
         params
      )

    request("sendVoice", json_body)
  end

  @doc """
  Same as `send_voice/2` but will raise `Telebrew.Error` on failure
  """
  def send_voice!(chat_id, voice, params \\ []) do
    send_voice(chat_id, voice, params) 
    |> check_error
  end

  @doc """
  Sends a video note(small square autoplay videos) that is up to 1 minute long

  ## Optional Parameters ##
  - `duration`: (Integer) Duration of video in seconds
  - `length`: (Integer) Video height and width
  - `disable_notification`: (Boolean) Sends message without sound or vibration
  - `reply_to_message_id`: (Integer) If message is a reply, ID of he original message
  - `reply_markup`: (Map) Additional interface options, go [here](#{@docs_address}#sendAudio) for more information
  """
  def send_video_note(chat_id, video_note, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        video_note: video_note
      }
      |> add_optional_params(
        [:duration, :length, :disable_notification,
         :reply_to_message_id, :reply_markup],
         params
      )

      request("sendVideoNote", json_body)
  end

  @doc """
  Same as `send_video_note/2` but will raise `Telebrew.Error` on failure
  """
  def send_video_note!(chat_id, video_note, params \\ []) do
    send_video_note(chat_id, video_note, params)
    |> check_error
  end


  # Helper Functions


  defp check_error({:ok, resp}), do: resp

  defp check_error({:error, %{error_code: c, description: d}}) do
    raise Telebrew.Error, message: d, error_code: c
  end

  defp add_optional_params(map, param_names, params) do
    # Enum.reduce over the list of optional parameters, if it is not nil add it to the parameter map
    param_names
    |> Enum.reduce(map, fn name, acc ->
      val = Keyword.get(params, name)

      if val != nil do
        Map.put(acc, name, val)
      else
        acc
      end
    end)
  end
end

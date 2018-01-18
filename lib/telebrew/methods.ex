defmodule Telebrew.Methods do
  import Telebrew.HTTP

  @docs_address "https://core.telegram.org/bots/api"

  @typedoc """
  Basic user map type, represents all possible options
  """
  @type user :: %{
          :id => integer,
          :is_bot => boolean,
          :first_name => binary,
          optional(:last_name) => binary,
          optional(:username) => binary,
          optional(:language_code) => binary
        }

  @typedoc """
  Represents the chat photo
  """
  @type chat_photo :: %{
          small_file_id: binary,
          big_file_id: binary
        }

  @typedoc """
  Basic chat map type
  """
  @type chat :: %{
          :id => integer,
          :type => binary,
          optional(:title) => binary,
          optional(:username) => binary,
          optional(:first_name) => binary,
          optional(:last_name) => binary,
          optional(:all_members_are_administrators) => boolean,
          optional(:photo) => chat_photo,
          optional(:description) => binary,
          optional(:invite_link) => binary,
          optional(:pinned_message) => message,
          optional(:sticker_set_name) => binary,
          optional(:can_set_sticker_set) => boolean
        }

  @typedoc """
  Represents a special entity in a text message
  """
  @type message_entity :: %{
          :type => binary,
          :offset => integer,
          :length => integer,
          optional(:url) => binary,
          optional(:user) => user
        }

  @typedoc """
  Represents an audio file
  """
  @type audio :: %{
          :file_id => binary,
          :duration => integer,
          optional(:performer) => binary,
          optional(:title) => binary,
          optional(:mime_type) => binary,
          optional(:file_size) => integer
        }

  @typedoc """
  Represents one size of a photo or file thumbnail
  """
  @type photo_size :: %{
          :file_id => binary,
          :width => integer,
          :height => integer,
          optional(:file_size) => integer
        }

  @typedoc """
  Represents a general file
  """
  @type document :: %{
          :file_id => binary,
          optional(:thumb) => photo_size,
          optional(:file_name) => binary,
          optional(:mime_type) => binary,
          optional(:file_size) => integer
        }

  @typedoc """
  Represents a game animation
  """
  @type animation :: %{
          :file_id => binary,
          optional(:thumb) => photo_size,
          optional(:file_name) => binary,
          optional(:mime_type) => binary,
          optional(:file_size) => integer
        }

  @typedoc """
  Represents a game
  """
  @type game :: %{
          :title => binary,
          :description => binary,
          optional(:photo) => list(photo_size),
          optional(:text) => binary,
          optional(:text_entities) => list(message_entity),
          optional(:animation) => animation
        }

  @typedoc """
  Describes the position on faces where a mask should be placed by default
  """
  @type mask_position :: %{
          point: binary,
          x_shift: float,
          y_shift: float,
          scale: float
        }

  @typedoc """
  Represents a sticker
  """
  @type sticker :: %{
          :file_id => binary,
          :width => integer,
          :height => integer,
          optional(:thumb) => photo_size,
          optional(:emoji) => binary,
          optional(:set_name) => binary,
          optional(:mask_position) => mask_position,
          optional(:file_size) => integer
        }

  @typedoc """
  Represents a video file
  """
  @type video :: %{
          :file_id => binary,
          :width => integer,
          :height => integer,
          :duration => integer,
          optional(:thumb) => photo_size,
          optional(:mime_type) => binary,
          optional(:file_size) => integer
        }

  @typedoc """
  Represents a voice note
  """
  @type voice :: %{
          :file_id => binary,
          :duration => integer,
          optional(:mime_type) => binary,
          optional(:file_size) => integer
        }

  @typedoc """
  Represents a video note
  """
  @type video_note :: %{
          :file_id => binary,
          :length => integer,
          :duration => integer,
          optional(:thumb) => photo_size,
          optional(:file_size) => integer
        }

  @typedoc """
  Represents a phone contact
  """
  @type contact :: %{
          :phone_number => binary,
          :first_name => binary,
          optional(:last_name) => binary,
          optional(:user_id) => integer
        }

  @typedoc """
  Represents a point on a map
  """
  @type location :: %{longitude: float, latitude: float}

  @typedoc """
  Represents a venue
  """
  @type venue :: %{
          :location => location,
          :title => binary,
          :address => binary,
          optional(:foursquare_id) => binary
        }

  @typedoc """
  Contains basic information about an invoice
  """
  @type invoice :: %{
          title: binary,
          description: binary,
          start_parameter: binary,
          currency: binary,
          total_amount: integer
        }

  @typedoc """
  Represents a shipping address
  """
  @type shipping_address :: %{
          country_code: binary,
          state: binary,
          city: binary,
          street_line1: binary,
          street_line2: binary,
          post_code: binary
        }

  @typedoc """
  Represents information about an order
  """
  @type order_info :: %{
          optional(:name) => binary,
          optional(:phone_number) => binary,
          optional(:email) => binary,
          optional(:shipping_address) => shipping_address
        }

  @typedoc """
  Contains basic information about a successful payment
  """
  @type successful_payment :: %{
          :currency => binary,
          :total_amount => integer,
          :invoice_payload => binary,
          :telegram_payment_charge_id => binary,
          :provider_payment_charge_id => binary,
          optional(:shipping_option_id) => binary,
          optional(:order_info) => order_info
        }

  @typedoc """
  Basic message map type given to listeners when they are called
  """
  @type message :: %{
          :message_id => integer,
          :from => user,
          :date => integer,
          :chat => chat,
          optional(:forward_from) => user,
          optional(:forward_from_chat) => chat,
          optional(:forward_from_message_id) => integer,
          optional(:forward_signature) => binary,
          optional(:forward_date) => integer,
          optional(:reply_to_message) => message,
          optional(:edit_date) => integer,
          optional(:media_group_id) => binary,
          optional(:author_signature) => binary,
          optional(:text) => binary,
          optional(:entities) => list(message_entity),
          optional(:caption_entities) => list(message_entity),
          optional(:audio) => audio,
          optional(:document) => document,
          optional(:game) => game,
          optional(:photo) => list(photo_size),
          optional(:sticker) => sticker,
          optional(:video) => video,
          optional(:voice) => voice,
          optional(:video_note) => video_note,
          optional(:caption) => binary,
          optional(:contact) => contact,
          optional(:location) => location,
          optional(:venue) => venue,
          optional(:new_chat_members) => list(user),
          optional(:left_chat_member) => user,
          optional(:new_chat_title) => binary,
          optional(:new_chat_photo) => list(photo_size),
          optional(:delete_chat_photo) => true,
          optional(:group_chat_created) => true,
          optional(:supergroup_chat_created) => true,
          optional(:channel_chat_created) => true,
          optional(:migrate_to_chat_id) => integer,
          optional(:migrate_from_chat_id) => integer,
          optional(:pinned_message) => message,
          optional(:invoice) => invoice,
          optional(:successful_payment) => successful_payment
        }

  @typedoc """
  Represents a file ready to be downloaded
  """
  @type file :: %{
          :file_id => binary,
          optional(:file_size) => integer,
          optional(:file_path) => binary
        }

  @typedoc """
  Represents the result of a message function
  """
  @type result(return) :: {:ok, return} | {:error, %{error_code: integer, description: binary}}

  @typedoc """
  Represents possible types for a chat_id
  """
  @type chat_id :: integer | binary

  @typedoc """
  Represents a photo to be sent
  """
  @type input_media_photo :: %{
          :type => binary,
          :media => binary,
          optional(:caption) => binary
        }

  @typedoc """
  Represents a video to be sent
  """
  @type input_media_video :: %{
          :type => binary,
          :media => binary,
          optional(:caption) => binary,
          optional(:width) => integer,
          optional(:height) => integer,
          optional(:duration) => integer
        }

  @typedoc """
  Represents the content of a media message
  """
  @type input_media :: input_media_photo | input_media_video

  @typedoc """
  Represents a user's profile pictures
  """
  @type user_profile_photos :: %{
          total_count: integer,
          photos: list(list(photo_size))
        }

  @moduledoc """
  This module stores all of the abstractions over the telegram bot api methods
  """

  @doc """
  Sends a message to the given chat_id

  ## Optional Parameters ##

  - `parse_mode`: (String) Use "Markdown" or "HTML" to have telegram parse the message with the respective markdown style
  - `disable_web_page_preview`: (Boolean) Disables preview of webpages when a link is in the message
  - `disable_notification`: (Boolean) Disables sound or vibration of the message
  - `reply_to_message_id`: (Integer) If the message is a reply, ID of the original message
  - `reply_markup`: (Map) Additional interface options, go [here](#{@docs_address}#sendmessage) for more information about this option

  ## Example ##
      # will send the message "Hello" to the chat_id 123456789 without a notification
      send_message(123456789, "Hello", disable_notification: true)

  """
  @spec send_message(chat_id, binary, keyword) :: result(message)
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
  @spec send_message!(chat_id, binary, keyword) :: message
  def send_message!(chat_id, message, params \\ []) do
    send_message(chat_id, message, params)
    |> check_error
  end

  @doc """
  Returns basic information about the bot in the form of a User object
  """
  @spec get_me() :: result(user)
  def get_me(), do: request("getMe", %{})

  @doc """
  Same as `get_me/0` but will raise `Telebrew.Error` exception on failure
  """
  @spec get_me!() :: user
  def get_me!(), do: request("getMe", %{}) |> check_error

  @doc """
  Forward messages of any kind

  ## Optional Parameters ##

  - `disable_notification`: (Boolean) Disables notification sound or vibration
  """
  @spec forward_message(chat_id, chat_id, integer, keyword) :: result(message)
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
  @spec forward_message!(chat_id, chat_id, integer, keyword) :: message
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
    - `reply_markup`: (Map) Additional interface options go [here](#{@docs_address}#sendphoto) for more info

  ## Example ##
      # will echo a photo back to the user with the caption "echo"
      on "photo" do
        photo = List.first m.photo
        send_photo m.chat.id, photo.file_id, caption: "echo"
      end
  """
  @spec send_photo(chat_id, binary | %{}, keyword) :: result(message)
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
  @spec send_photo!(chat_id, binary | %{}, keyword) :: message
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
  - `reply_markup`: (Map) Additional interface options, go [here](#{@docs_address}#sendaudio) for more information
  """
  @spec send_audio(chat_id, binary | %{}, keyword) :: result(message)
  def send_audio(chat_id, audio, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        audio: audio
      }
      |> add_optional_params(
        [
          :caption,
          :duration,
          :performer,
          :title,
          :disable_notification,
          :reply_to_message_id,
          :reply_markup
        ],
        params
      )

    request("sendAudio", json_body)
  end

  @doc """
  Same as `send_audio/2` but will raise `Telebrew.Error` on failure
  """
  @spec send_audio!(chat_id, binary | %{}, keyword) :: message
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
  - `reply_markup`: (Map) Additional interface options, go [here](#{@docs_address}#senddocument) for more information
  """
  @spec send_document(chat_id, binary | %{}, keyword) :: result(message)
  def send_document(chat_id, document, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        document: document
      }
      |> add_optional_params(
        [:caption, :disable_notification, :reply_to_message_id, :reply_markup],
        params
      )

    request("sendDocument", json_body)
  end

  @doc """
  Same as `send_document/2` but will raise `Telebrew.Error` on failure
  """
  @spec send_document!(chat_id, binary | %{}, keyword) :: message
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
  - `reply_markup`: (Map) Additional interface options, go [here](#{@docs_address}#sendvideo) for more information
  """
  @spec send_video(chat_id, binary | %{}, keyword) :: result(message)
  def send_video(chat_id, video, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        video: video
      }
      |> add_optional_params(
        [
          :duration,
          :width,
          :height,
          :caption,
          :disable_notification,
          :reply_to_message_id,
          :reply_markup
        ],
        params
      )

    request("sendVideo", json_body)
  end

  @doc """
  Same as `send_video/2` but will raise `Telebrew.Error` on failure
  """
  @spec send_video!(chat_id, binary | %{}, keyword) :: message
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
  - `reply_markup`: (Map) Additional interface options, go [here](#{@docs_address}#sendvoice) for more information
  """
  @spec send_voice(chat_id, binary | %{}, keyword) :: result(message)
  def send_voice(chat_id, voice, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        voice: voice
      }
      |> add_optional_params(
        [:caption, :duration, :disable_notification, :reply_to_message_id, :reply_markup],
        params
      )

    request("sendVoice", json_body)
  end

  @doc """
  Same as `send_voice/2` but will raise `Telebrew.Error` on failure
  """
  @spec send_voice!(chat_id, binary | %{}, keyword) :: message
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
  - `reply_markup`: (Map) Additional interface options, go [here](#{@docs_address}#sendvideonote) for more information
  """
  @spec send_video_note(chat_id, binary | %{}, keyword) :: result(message)
  def send_video_note(chat_id, video_note, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        video_note: video_note
      }
      |> add_optional_params(
        [:duration, :length, :disable_notification, :reply_to_message_id, :reply_markup],
        params
      )

    request("sendVideoNote", json_body)
  end

  @doc """
  Same as `send_video_note/2` but will raise `Telebrew.Error` on failure
  """
  @spec send_video_note!(chat_id, binary | %{}, keyword) :: message
  def send_video_note!(chat_id, video_note, params \\ []) do
    send_video_note(chat_id, video_note, params)
    |> check_error
  end

  @doc """
  Sends a group of photos or videos as an album. On success an array of messages is returned

  The second parameter `media` is of type InputMedia described [here](#{@docs_address}#inputmedia)

  ## Optional Parameters ##
  - `disable_notification`: (Boolean) Sends message without sound or vibration
  - `reply_to_message_id`: (Integer) If message is a reply, ID of he original message
  """
  @spec send_media_group(chat_id, list(input_media), keyword) :: result(message)
  def send_media_group(chat_id, media, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        media: media
      }
      |> add_optional_params(
        [:disable_notification, :reply_to_message_id],
        params
      )

    request("sendMediaGroup", json_body)
  end

  @doc """
  Same as `send_media_group/2` but will raise `Telebrew.Error` on failure
  """
  @spec send_media_group!(chat_id, list(input_media), keyword) :: message
  def send_media_group!(chat_id, media, params \\ []) do
    send_media_group(chat_id, media, params)
    |> check_error
  end

  @doc """
  Sends a location in the form of a latitude and longitude

  ## Optional Parameters ##
  - `live_period`: (Integer) Period in seconds for which the location will be updated.  Should be between 60 and 86400.
  - `disable_notification`: (Boolean) Sends message without sound or vibration
  - `reply_to_message_id`: (Integer) If message is a reply, ID of he original message
  - `reply_markup`: (Map) Additional interface options, go [here](#{@docs_address}#sendlocation) for more information
  """
  @spec send_location(chat_id, float, float, keyword) :: result(message)
  def send_location(chat_id, latitude, longitude, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        latitude: latitude,
        longitude: longitude
      }
      |> add_optional_params(
        [:live_period, :disable_notification, :reply_to_message_id, :reply_markup],
        params
      )

    request("sendLocation", json_body)
  end

  @doc """
  Same as `send_location/2` but will raise `Telebrew.Error` on failure
  """
  @spec send_location!(chat_id, float, float, keyword) :: message
  def send_location!(chat_id, latitude, longitude, params \\ []) do
    send_location(chat_id, latitude, longitude, params)
    |> check_error
  end

  @doc """
  Updates the location of a live location message sent by the bot
  or via the bot.

  Either chat_id and message_id or only inline_message_id are required to identify the message to update

  ## Parameters ##
  - `chat_id`: (Integer or String) Id of the chat the location is in **required if no inline_message_id**
  - `message_id`: (Integer) Id of the location message to update **required if no inline_message_id**
  - `inline_message_id`: (String) Id of the inline message **required if no chat_id and message_id**
  - `reply_markup`: (Map) JSON-serialized object for a new inline keyboard see [here](#{
    @docs_address
  }#editmessagelivelocation)
  """
  @spec edit_message_live_location(float, float, keyword) :: result(message)
  def edit_message_live_location(latitude, longitude, params \\ []) do
    json_body =
      cond do
        Keyword.has_key?(params, :inline_message_id) ->
          %{
            inline_message_id: Keyword.get(params, :inline_message_id),
            latitude: latitude,
            longitude: longitude
          }
          |> add_optional_params([:reply_markup], params)

        Keyword.has_key?(params, :chat_id) and Keyword.has_key?(params, :message_id) ->
          %{
            chat_id: Keyword.get(params, :chat_id),
            message_id: Keyword.get(params, :message_id),
            latitude: latitude,
            longitude: longitude
          }
          |> add_optional_params([:reply_markup], params)

        true ->
          raise Telebrew.SyntaxError,
            message:
              "edit_message_live_location params must contain either chat_id and message_id or only inline_message_id"
      end

    request("editMessageLiveLocation", json_body)
  end

  @doc """
  Same as `edit_message_live_location/4` and `edit_message_live_location/3`
  but will raise `Telebrew.Error` on failure
  """
  @spec edit_message_live_location!(float, float, keyword) :: message
  def edit_message_live_location!(latitude, longitude, params \\ []) do
    edit_message_live_location(latitude, longitude, params)
    |> check_error
  end

  @doc """
  Stops the live location of a location message

  Either chat_id and message_id or only inline_message_id are required to identify the message to update

  ## Parameters ##
  - `chat_id`: (Integer or String) Id of the chat the location is in **required if no inline_message_id**
  - `message_id`: (Integer) Id of the location message to update **required if no inline_message_id**
  - `inline_message_id`: (String) Id of the inline message **required if no chat_id and message_id**
  - `reply_markup`: (Map) JSON-serialized object for a new inline keyboard see [here](#{
    @docs_address
  }#stopmessagelivelocation)
  """
  @spec stop_message_live_location(keyword) :: result(message)
  def stop_message_live_location(params \\ []) do
    json_body =
      cond do
        Keyword.has_key?(params, :inline_message_id) ->
          %{
            inline_message_id: Keyword.get(params, :inline_message_id)
          }
          |> add_optional_params([:reply_markup], params)

        Keyword.has_key?(params, :chat_id) and Keyword.has_key?(params, :message_id) ->
          %{
            chat_id: Keyword.get(params, :chat_id),
            message_id: Keyword.get(params, :message_id)
          }
          |> add_optional_params([:reply_markup], params)

        true ->
          raise Telebrew.SyntaxError,
            message:
              "stop_message_live_location params must contain either chat_id and message_id or only inline_message_id"
      end

    request("stopMessageLiveLocation", json_body)
  end

  @doc """
  Same as `stop_message_live_location/0` but will raise `Telebrew.Error` on failure
  """
  @spec stop_message_live_location!(keyword) :: message
  def stop_message_live_location!(params \\ []) do
    stop_message_live_location(params)
    |> check_error
  end

  @doc """
  Sends information about a venue

  ## Optional Parameters ##
  - `foursquare_id`: (String) Foursquare identifier of the venue
  - `disable_notification`: (Boolean) Sends message without sound or vibration
  - `reply_to_message_id`: (Integer) If message is a reply, ID of he original message
  - `reply_markup`: (Map) Additional interface options, go [here](#{@docs_address}#sendvenue) for more information
  """
  @spec send_venue(chat_id, float, float, binary, binary, keyword) :: result(message)
  def send_venue(chat_id, latitude, longitude, title, address, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        latitude: latitude,
        longitude: longitude,
        title: title,
        address: address
      }
      |> add_optional_params(
        [:foursquare_id, :disable_notification, :reply_to_message_id, :reply_markup],
        params
      )

    request("sendVenue", json_body)
  end

  @doc """
  Same as `send_venue/5` but will raise `Telebrew.Error` on failure
  """
  @spec send_venue!(chat_id, float, float, binary, binary, keyword) :: message
  def send_venue!(chat_id, latitude, longitude, title, address, params \\ []) do
    send_venue(chat_id, latitude, longitude, title, address, params)
    |> check_error
  end

  @doc """
  Sends phone contact information

  ## Optional Parameters ##
  - `last_name`: (String) Contact's last name
  - `disable_notification`: (Boolean) Sends message without sound or vibration
  - `reply_to_message_id`: (Integer) If message is a reply, ID of he original message
  - `reply_markup`: (Map) Additional interface options, go [here](#{@docs_address}#sendcontact) for more information
  """
  @spec send_contact(chat_id, binary, binary, keyword) :: result(message)
  def send_contact(chat_id, phone_number, first_name, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        phone_number: phone_number,
        first_name: first_name
      }
      |> add_optional_params(
        [:last_name, :disable_notification, :reply_to_message_id, :reply_markup],
        params
      )

    request("sendContact", json_body)
  end

  @doc """
  Same as `send_contact/3` but will raise `Telebrew.Error` on failure
  """
  @spec send_contact!(chat_id, binary, binary, keyword) :: message
  def send_contact!(chat_id, phone_number, first_name, params \\ []) do
    send_contact(chat_id, phone_number, first_name, params)
    |> check_error
  end

  @doc """
  Used to tell the user something is happening on the bot's side.  The status will appear for 5 seconds or less

  ## Actions ##
  - `typing`
  - `upload_photo`
  - `record_video`
  - `upload_video`
  - `record_audio`
  - `upload_audio`
  - `upload_document`
  - `find_location`
  - `record_video_note`
  - `upload_video_note`
  """
  @spec send_chat_action(chat_id, binary) :: result(boolean)
  def send_chat_action(chat_id, action) do
    json_body = %{
      chat_id: chat_id,
      action: action
    }

    request("sendChatAction", json_body)
  end

  @doc """
  Same as `send_chat_action/2` but will throw `Telebrew.Error` on failure
  """
  @spec send_chat_action!(chat_id, binary) :: boolean
  def send_chat_action!(chat_id, action) do
    send_chat_action(chat_id, action)
    |> check_error
  end

  @doc """
  Use to get a list of profile pictures for a user

  ## Optional Parameters ##
  - `offset` (Integer) Sequential number of the first photo to be returned
  - `limit` (Integer) Limites the number of photos to be returned, 1-100
  """
  @spec get_user_profile_photos(integer, keyword) :: result(user_profile_photos)
  def get_user_profile_photos(user_id, params \\ []) do
    json_body =
      %{
        user_id: user_id
      }
      |> add_optional_params(
        [:offset, :limit],
        params
      )

    request("getUserProfilePhotos", json_body)
  end

  @doc """
  Same as `get_user`profile_photos/1` but will raise `Telebrew.Error` on failure
  """
  @spec get_user_profile_photos!(integer, keyword) :: user_profile_photos
  def get_user_profile_photos!(user_id, params \\ []) do
    get_user_profile_photos(user_id, params)
    |> check_error
  end

  @doc """
  Used to get basic information about a file
  """
  @spec get_file(binary) :: result(file)
  def get_file(file_id), do: request("getFile", %{file_id: file_id})

  @doc """
  Same as `get_file/1` but will raise `Telebrew.Error` on failure
  """
  @spec get_file!(binary) :: file
  def get_file!(file_id), do: get_file(file_id) |> check_error

  @doc """
  Will download a file to the given destination
  """
  @spec download_file(binary, binary) :: {:error, binary} | {:error, atom} | :ok
  def download_file(file_id, destination) do
    case get_file(file_id) do
      {:ok, file} ->
        http_download_file(file.file_path, destination)

      x ->
        x
    end
  end

  @doc """
  Same as `download_file/2` but will raise `Telebrew.Error` on failure
  """
  @spec download_file!(binary, binary) :: :ok
  def download_file!(file_id, destination) do
    http_download_file(file_id, destination)
    |> check_error
  end

  @doc """
  Used to kick a user from a group.

  The bot must have admin privilages and the 'All Members Are Admins' must be disabled

  ## Optional Parameter ##
  - `until_date`: (Integer) Date when the user will be unbanned.  If the user is banned for more than 366 days or less than 30 seconds from the current time they are banned forever
  """
  @spec kick_chat_member(chat_id, integer, keyword) :: result(true)
  def kick_chat_member(chat_id, user_id, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        user_id: user_id
      }
      |> add_optional_params([:until_date], params)

    request("kickChatMember", json_body)
  end

  @doc """
  Same as `kick_chat_member/2` but will raise `Telebrew.Error` on failure
  """
  @spec kick_chat_member!(chat_id, integer, keyword) :: true
  def kick_chat_member!(chat_id, user_id, params \\ []) do
    kick_chat_member(chat_id, user_id, params)
    |> check_error
  end

  @doc """
  Used to unban a previously kicked user in a supergroup or channel.
  """
  @spec unban_chat_member(chat_id, integer) :: result(true)
  def unban_chat_member(chat_id, user_id) do
    json_body = %{
      chat_id: chat_id,
      user_id: user_id
    }

    request("unbanChatMember", json_body)
  end

  @doc """
  Same as `unban_chat_member/2` but will raise `Telebrew.Error` on failure
  """
  @spec unban_chat_member!(chat_id, integer) :: true
  def unban_chat_member!(chat_id, user_id) do
    unban_chat_member(chat_id, user_id)
    |> check_error
  end

  # TODO: Test
  @doc """
  Used to restrict a user in a supergroup.

  The bot must be an administrator and have appropriot admin rights.

  Pass true to all parameters to lift all restrictions.

  ## Optional Parameters ##
  - `until_date`: (Integer) Date when restrictions will be lifted for the user.  In unix time.
  - `can_send_messages`: (Boolean) Determines if the user should be able to send messages
  - `can_send_media_messages`: (Boolean) Determines if the user should be able to send files
  - `can_send_other_messages`: (Boolean) Determines if the user should be able to send animations, games, stickers, and user inline bots
  - `can_add_web_page_previews`: (Boolean) Determines if the user should be able to add web page previews to their messages
  """
  @spec restrict_chat_member(chat_id, integer, keyword) :: result(:true)
  def restrict_chat_member(chat_id, user_id, params \\ []) do
    json_body = 
      %{
        chat_id: chat_id,
        user_id: user_id
      }
      |> add_optional_params(
        [:until_date,
         :can_send_messages,
         :can_send_media_messages,
         :can_send_other_messages,
         :can_add_web_page_previews],
         params
      )

      request("restrictChatMember", json_body)
  end

  # TODO: Test
  @doc """
  Same as `restrict_chat_member/2` but will raise `Telebrew.Error` on failure
  """
  @spec restrict_chat_member!(chat_id, integer, keyword) :: :true 
  def restrict_chat_member!(chat_id, user_id, params \\ []) do
    restrict_chat_member(chat_id, user_id, params)
    |> check_error
  end

  # TODO: Test
  @doc """
  Used to promote or demote a user in a supergroup or channel.

  The bot must be an administrator with appropriate admin rights.

  Pass false for all boolean parameters to demote a user.

  ## Optional Parameters ##
  - `can_change_info`: (Boolean) Determines if admin can change chat title, photo, or other settings
  - `can_post_messages`: (Boolean) Determines if admin can create channel posts
  - `can_edit_messages`: (Boolean) Determines if admin can edit other user's messages
  - `can_delete_messages`: (Boolean) Determines if admin can delete other user's messages
  - `can_invite_users`: (Boolean) Determines if admin can invite new users
  - `can_restrict_members`: (Boolean) Determines if admin can restrict, ban, or unban chat members
  - `can_pin_messages`: (Boolean) Determines if admin can in messages, supergroups only
  - `can_promote_members`: (Boolean) Determines if admin can add new administrators or demote administrators that it has promoted
  """
  @spec promote_chat_member(chat_id, integer, keyword) :: result(:true)  
  def promote_chat_member(chat_id, user_id, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        user_id: user_id
      }
      |> add_optional_params(
        [:can_change_info,
         :can_post_messages,
         :can_edit_messages,
         :can_delete_messages,
         :can_invite_users,
         :can_restrict_members,
         :can_pin_messages,
         :can_promote_members],
         params
      )

    request("promoteChatMember", json_body)
  end

  # TODO: Test
  @doc """
  Same as `promote_chat_member/2` but will raise `Telebrew.Error` on failure
  """
  @spec promote_chat_member!(chat_id, integer, keyword) :: :true
  def promote_chat_member!(chat_id, user_id, params \\ []) do
    promote_chat_member(chat_id, user_id, params)
    |> check_error
  end

  @doc """
  Used to export an invite link to a supergroup or channel.

  Bot must be an administrator with appropriate admin rights.
  """
  @spec export_chat_invite_link(chat_id) :: result(binary)
  def export_chat_invite_link(chat_id) do
    json_body = %{chat_id: chat_id}

    request("exportChatInviteLink", json_body)
  end

  @doc """
  Same as `export_chat_invite_link/1` but will raise `Telebrew.Error` on failure
  """
  @spec export_chat_invite_link!(chat_id) :: binary
  def export_chat_invite_link!(chat_id) do
    export_chat_invite_link(chat_id)
    |> check_error
  end

  # TODO: Test
  @doc """
  Used to set a new profile photo for non-private chats.

  The bot must be an administrator with proper rights. In non-supergroups this will only work if 
  the 'All Members Are Admins' setting is off.
  """
  @spec set_chat_photo(chat_id, %{}) :: result(:true)
  def set_chat_photo(chat_id, photo) do
    json_body =
      %{
        chat_id: chat_id,
        photo: photo
      }

    request("setChatPhoto", json_body)
  end

  # TODO: Test
  @doc """
  Same as `set_chat_photo/2` but will raise `Telebrew.Error` on failure
  """
  @spec set_chat_photo!(chat_id, %{}) :: :true
  def set_chat_photo!(chat_id, photo) do
    set_chat_photo(chat_id, photo)
    |> check_error
  end

  # TODO: Test
  @doc """
  Used to delete the chat photo

  The bot must be an administrator with proper rights. In non-supergroups this will only work if 
  the 'All Members Are Admins' setting is off.
  """
  @spec delete_chat_photo(chat_id) :: result(:true)
  def delete_chat_photo(chat_id), do: request("deleteChatPhoto", %{chat_id: chat_id})

  # TODO: Test
  @doc """
  Same as `delete_chat_photo/1` but will raise `Telebrew.Error` on failure
  """
  @spec delete_Chat_photo!(chat_id) :: :true
  def delete_chat_photo!(chat_id), do: delete_chat_photo(chat_id) |> check_error

  # TODO: Test
  @doc """
  Used to set the title of the chat

  The bot must be an administrator with proper rights.  In non-supergroups this will only work if 
  the 'All Members Are Admins' setting is off.
  """
  @spec set_chat_title(chat_id, binary) :: result(:true)
  def set_chat_title(chat_id, title) do
    json_body = 
      %{
        chat_id: chat_id,
        title: title
      }

    request("setChatTitle", json_body)
  end

  # TODO: Test
  @doc """
  Same as `set_chat_title/2` but will raise `Telebrew.Error` on failure
  """
  @spec set_chat_title!(chat_id, binary) :: :true
  def set_chat_title!(chat_id, title) do
    set_chat_title(chat_id, title)
    |> check_error
  end

  # TODO: Test
  @doc """
  Used to change the description of a supergroup or channel

  The bot must be an administrator with proper rights

  ## Optional Parameters ##
  - `description`: (String) New description, 0-255 characters
  """
  @spec set_chat_description(chat_id, keyword) :: result(:true)
  def set_chat_description(chat_id, params \\ []) do
    json_body =
      %{
        chat_id: chat_id
      }
      |> add_optional_params([:description], params)

    request("setChatDescription", json_body)
  end

  # TODO: Test
  @doc """
  Same as `set_chat_description/1` but will raise `Telebrew.Error` on failure
  """
  def set_chat_description!(chat_id, params \\ []) do
    set_chat_description(chat_id, params)
    |> check_error
  end

  # TODO: Test
  @doc """
  Used to pin a message in a supergroup or a channel.

  The bot must be an administrator and must have the 'can_pin_messages' admin right in a supergroup or
  the 'can_edit_messages' admin right in a channel
  """
  @spec pin_chat_message(chat_id, integer, keyword) :: result(:true)
  def pin_chat_message(chat_id, message_id, params \\ []) do
    json_body =
      %{
        chat_id: chat_id,
        message_id: message_id
      }
      |> add_optional_params([:disable_notification], params)

    request("pinChatMessage", json_body)
  end

  # TODO: Test
  @doc """
  Same as `pin_chat_message/2` but will raise `Telebrew.Error` on failure
  """
  @spec pin_chat_message!(chat_id, integer, keyword) :: :true
  def pin_chat_message!(chat_id, message_id, params \\ []) do
    pin_chat_message(chat_id, message_id, params)
    |> check_error
  end

  # TODO: Test
  @doc """
  Used to unpin a message in a supergroup or channel

  The bot must be an administrator and must have the 'can_pin_messages' admin right in a supergroup or
  the 'can_edit_messages' admin right in a channel
  """
  @spec unpin_chat_message(chat_id) :: result(:true)
  def unpin_chat_message(chat_id) do
    request("unpinChatMessage", %{chat_id: chat_id})
  end

  # TODO: Test
  @doc """
  Same as `unpin_chat_message/1` but will raise `Telebrew.Error` on failure
  """
  @spec unpin_chat_message!(chat_id) :: :true
  def unpin_chat_message!(chat_id) do
    unpin_chat_message(chat_id)
    |> check_error
  end

  # Helper Functions

  defp check_error({:ok, resp}), do: resp

  defp check_error({:error, %{error_code: c, description: d}}) do
    raise Telebrew.Error, message: d, error_code: c
  end

  defp check_error({:error, reason}) do
    raise Telebrew.Error, message: reason
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

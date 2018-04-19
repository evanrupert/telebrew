defmodule Telebrew.Listener do
  use GenServer, restart: :transient

  require Logger

  alias Telebrew.Listener.Data
  alias Telebrew.ReservedEvents

  # Client

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def update(message) do
    GenServer.cast(__MODULE__, {:update, message})
  end

  # Server callbacks

  @impl true
  def init(_args) do
    # Get initial state from stash server that holds state in case of failure
    listener_data = GenServer.call(Telebrew.Stash, :get)
    {:ok, listener_data}
  end

  @impl true
  def terminate(_reason, listener_data) do
    # Send current state to stash server to save it through restarts
    GenServer.cast(Telebrew.Stash, {:save, listener_data})
  end

  @impl true
  def handle_cast({:update, message}, listener_data) do
    log_message(message)

    updated_listener_data = call_listener(message, listener_data)

    {:noreply, updated_listener_data}
  end

  defp call_listener(message, listener_data) do
    if is_command?(message) do
      handle_command(message, listener_data)
    else
      handle_event(message, listener_data)
    end
  end

  defp is_command?(message) do
    Map.has_key?(message, :text) and String.starts_with?(message.text, "/")
  end

  defp handle_command(message, listener_data) do
    {command, message_without_command} = seperate_command_from_message(message)

    matched = find_match(listener_data.listeners, command)

    cond do
      matched ->
        call_listener(matched, message_without_command, listener_data)

      has_default_function?(listener_data.module) ->
        call_listener(:default, message_without_command, listener_data)

      true ->
        listener_data
    end
  end

  defp seperate_command_from_message(message) do
    [fst | rest] = String.split(message.text, " ")
    {fst, %{message | text: Enum.join(rest, " ")}}
  end

  defp find_match(listeners, command) do
    command_atom = String.to_atom(command)
    Enum.find(listeners, fn listener -> listener == command_atom end)
  end

  def call_listener(listener, message, listener_data) do
    current_chat_state = get_chat_state(message, listener_data)
    updated_state = apply(listener_data.module, listener, [message, current_chat_state])

    Data.update_current_chat_state(listener_data, message.chat.id, updated_state)
  end

  defp handle_event(message, listener_data) do
    with {true, updated_state} <- update_state_on_valid_match(message, listener_data) do
      Data.update_current_chat_state(listener_data, message.chat.id, updated_state)
    else
      {false, _old_state} ->
        if has_default_function?(listener_data.module) do
          call_listener(:default, message, listener_data)
        else
          listener_data
        end
    end
  end

  defp update_state_on_valid_match(message, listener_data) do
    initial_state = listener_data.state.initial
    current_chat_state = get_chat_state(message, listener_data)

    ReservedEvents.get()
    |> Enum.reduce({false, initial_state}, fn event, {matched, initial} ->
      if not matched and is_valid_listener_match?(message, event, listener_data.module) do
        {true, apply(listener_data.module, event, [message, current_chat_state])}
      else
        {matched, initial}
      end
    end)
  end

  defp is_valid_listener_match?(message, event, module) do
    Map.has_key?(message, event) and Keyword.has_key?(module.__info__(:functions), event)
  end

  defp get_chat_state(message, listener_data) do
    all_chat_states = listener_data.state.all_chats
    default_state = listener_data.state.initial

    Map.get(all_chat_states, message.chat.id, default_state)
  end

  defp has_default_function?(module) do
    Keyword.has_key?(module.__info__(:functions), :default)
  end

  defp log_message(message) do
    # Find the type of message then display a special log message based on the type
    log_message =
      cond do
        Map.has_key?(message, :text) ->
          message.text

        Map.has_key?(message, :photo) ->
          file_id = List.first(message.photo).file_id
          "Photo(#{file_id})"

        Map.has_key?(message, :sticker) ->
          file_id = message.sticker.file_id
          "Sticker(file_id)"

        Map.has_key?(message, :audio) ->
          file_id = message.audio.file_id
          "Audio(#{file_id})"

        Map.has_key?(message, :voice) ->
          file_id = message.voice.file_id
          "Voice(#{file_id})"

        Map.has_key?(message, :document) ->
          file_id = message.document.file_id
          "Document(#{file_id})"

        Map.has_key?(message, :video) ->
          file_id = message.video.file_id
          "Video(#{file_id})"

        Map.has_key?(message, :video_note) ->
          file_id = message.video_note.file_id
          "Video Note(#{file_id})"

        Map.has_key?(message, :venue) ->
          title = message.venue.title
          "Venue(#{title})"

        Map.has_key?(message, :contact) ->
          name = message.contact.first_name
          "Contact(#{name})"

        Map.has_key?(message, :location) ->
          lat = message.location.latitude
          lon = message.location.longitude
          "Location(#{lat}, #{lon})"

        true ->
          # DEBUG
          IO.inspect(message)
          "Unknown"
      end

    Logger.info("Received Message: #{log_message}")
  end

end

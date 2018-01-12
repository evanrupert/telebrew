defmodule Telebrew.Listener do
  use GenServer, restart: :transient

  require Logger

  # all events in order that they will be checked for
  @reserved_events [
    :text,
    :photo,
    :sticker,
    :audio,
    :document,
    :video,
    :video_note,
    :voice,
    :venue,
    :location,
    :default
  ]

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
    args = GenServer.call(Telebrew.Stash, :get)
    {:ok, args}
  end

  @impl true
  def terminate(_reason, state) do
    # Send current state to stash server to save it through restarts
    GenServer.cast(Telebrew.Stash, {:save, state})
  end

  @impl true
  def handle_cast({:update, message}, {module, events, state}) do
    log_message(message)

    new_state =
      cond do
        Map.has_key?(message, :text) and String.starts_with?(message.text, "/") ->
          handle_command(module, events, message, state)

        true ->
          handle_event(module, message, state)
      end

    {:noreply, {module, events, new_state}}
  end

  defp handle_command(module, cmd_listeners, message, state) do
    {cmd, msg} = split_message(message.text)
    # update text to remove command
    new_message = %{message | text: msg}

    cmd_atom = String.to_atom(cmd)
    # find the event to call based on the command
    match = Enum.find(cmd_listeners, fn x -> x == cmd_atom end)

    # call listeners and get new state
    cond do
      # if match exists call that function 
      match ->
        apply(module, match, [new_message, state])

      # if no match exists call default function
      Keyword.has_key?(module.__info__(:functions), :default) ->
        apply(module, :default, [new_message, state])

      # if no match and no default do nothing
      true ->
        state
    end
  end

  defp handle_event(module, message, state) do
    # reduce over all event types to find the matching listener
    {matched, new_state} =
      @reserved_events
      |> Enum.reduce({false, state}, fn event, {matched, state} ->
        # if the message is one of the events and a listener has been defined call it and replace the old state value
        if not matched and Map.has_key?(message, event) and Keyword.has_key?(module.__info__(:functions), event) do
          {true, apply(module, event, [message, state])}
        else
          {matched, state}
        end
      end)

    # if one of the reserved events was not matched and :default listener is defined call default listener
    if not matched and Keyword.has_key?(module.__info__(:functions), :default) do
      apply(module, :default, [message, state])
    else
      new_state
    end
  end

  defp log_message(message) do
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

  defp split_message(message) do
    [fst | rest] = String.split(message, " ")
    {fst, Enum.join(rest, " ")}
  end
end

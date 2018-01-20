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
    :contact,
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
      # Determine if the message should be handled as a command or event
      cond do
        Map.has_key?(message, :text) and String.starts_with?(message.text, "/") ->
          handle_command(module, events, message, state)

        true ->
          handle_event(module, message, state)
      end

    {:noreply, {module, events, new_state}}
  end

  defp handle_command(module, cmd_listeners, message, {start_state, states}) do
    {cmd, msg} = split_message(message.text)
    # update text to remove command
    new_message = %{message | text: msg}

    cmd_atom = String.to_atom(cmd)
    # find the event to call based on the command
    match = Enum.find(cmd_listeners, fn x -> x == cmd_atom end)

    chat_id = new_message.chat.id

    # Attempt to get this chat's state from the states map and if nil make a new entry for this chat starting at start state
    {state, new_states} = case states[chat_id] do
      nil -> 
        {start_state, Map.put(states, chat_id, start_state)}

      state ->
        {state, states}
    end
    # call listeners and get new state
    cond do
      # if match exists call that function 
      match ->
        new_state = apply(module, match, [new_message, state])
        {start_state, %{new_states | chat_id => new_state}}

      # if no match exists call default function
      Keyword.has_key?(module.__info__(:functions), :default) ->
        new_state = apply(module, :default, [new_message, state])
        {start_state, %{new_states | chat_id => new_state}}

      # if no match and no default do nothing
      true ->
        {start_state, %{new_states | chat_id => state}}
    end
  end

  defp handle_event(module, message, {start_state, states}) do
    chat_id = message.chat.id
    
    # Attempt to get this chat's state from the states map and if nil make a new entry for this chat starting at start state
    {state, new_states} = case states[chat_id] do
      nil -> 
        {start_state, Map.put(states, chat_id, start_state)}

      state ->
        {state, states}
    end

    # reduce over all event types to find the matching listener
    {matched, new_state} =
      @reserved_events
      |> Enum.reduce({false, state}, fn event, {matched, state} ->
        # if the message is one of the events and a listener has been defined call it and replace the old state value
        if not matched and Map.has_key?(message, event) and
             Keyword.has_key?(module.__info__(:functions), event) do

          {true, apply(module, event, [message, state])}
        else
          {matched, state}
        end
      end)

    # if one of the reserved events was not matched and :default listener is defined call default listener
    if not matched and Keyword.has_key?(module.__info__(:functions), :default) do
      new_state = apply(module, :default, [message, state])
      {start_state, %{new_states | chat_id => new_state}}
    else
      {start_state, %{new_states | chat_id => new_state}}
    end
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

  defp split_message(message) do
    [fst | rest] = String.split(message, " ")
    {fst, Enum.join(rest, " ")}
  end
end

defmodule Telebrew.Listener do
  use GenServer

  @reserved_events [:text, :default, :photo, :sticker, :audio, 
                    :document, :video, :video_note, :voice,
                    :location]

  def init(args) do
    {:ok, args}
  end

  def handle_cast({:update, message}, state = {module, events}) do
    log_message(message)

    cond do
      Map.has_key?(message, :text) and String.starts_with?(message.text, "/") ->
        handle_command(module, events, message)
      
      true ->
        handle_event(module, message)
    end

    {:noreply, state}
  end

  defp handle_command(module, events, message) do
    {cmd, msg} = split_message(message.text)
    # update text to remove command
    new_message = %{message | text: msg}
    cmd_atom = String.to_atom(cmd)
    # find the event to call based on the command
    match = Enum.find(events, fn x -> x == cmd_atom end)

    cond do
      # if match exists call that function 
      match ->
        spawn(module, match, [new_message])

      # if no match exists call default function
      Keyword.has_key?(module.__info__(:functions), :default) ->
        spawn(module, :default, [new_message])

      # if no match and no default do nothing
      true ->
        nil
    end
  end

  defp handle_event(module, message) do
    # check for all possible events
    for event <- @reserved_events do
      # call listener if message contains that event and that event has a listener defined
      if Map.has_key?(message, event) and Keyword.has_key?(module.__info__(:functions), event) do
        spawn(module, event, [message])
      end
    end
  end


  defp log_message(message) do
    log_message = 
    cond do
      Map.has_key?(message, :text) ->
        message.text
      Map.has_key?(message, :photo) ->
        file_id = (List.first(message.photo)).file_id
        "Photo(#{file_id})"
      Map.has_key?(message, :sticker) ->
        emoji = message.sticker.emoji
        set_name = message.sticker.set_name
        "Sticker(#{emoji}, #{set_name})"
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
        IO.inspect message
        "Unknown"
    end

    IO.puts "Received Message: #{log_message}"
  end

  defp split_message(message) do
    [fst | rest] = String.split(message, " ")
    {fst, Enum.join(rest, " ")}
  end
end

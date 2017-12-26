defmodule Telebrew.Listener do
  use GenServer

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
    cond do
      # message has photo and module has photo listener call photo listener
      Map.has_key?(message, :photo) and Keyword.has_key?(module.__info__(:functions), :photo) ->
        spawn(module, :photo, [message])

      # if message is sticker and module has sticker listener call sticker listener
      Map.has_key?(message, :sticker) and Keyword.has_key?(module.__info__(:functions), :sticker) ->
        spawn(module, :sticker, [message])

      # if message is audio and module has audio listener call audio listener
      Map.has_key?(message, :audio) and Keyword.has_key?(module.__info__(:functions), :audio) ->
        spawn(module, :audio, [message])

      # if message has text and text listener exists call text listener
      Map.has_key?(message, :text) and Keyword.has_key?(module.__info__(:functions), :text) ->
        spawn(module, :text, [message])

      # if none of the previous conditions then do nothing
      true ->
        nil
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
      true ->
        "Unknown"
    end

    IO.puts "Received Message: #{log_message}"
  end

  defp split_message(message) do
    [fst | rest] = String.split(message, " ")
    {fst, Enum.join(rest, " ")}
  end
end

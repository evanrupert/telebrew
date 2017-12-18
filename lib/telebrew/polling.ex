defmodule Telebrew.Polling do
  @moduledoc false
  
  @interval unless Application.get_env(:telegram_bot_wrapper, :polling_interval), 
                   do: 1000, 
                   else: Application.get_env(:telegram_bot_wrapper, :polling_interval)
  

  def start(pid, module, events) do
    spawn(__MODULE__, :polling, [pid, get_last_update_id()])

    listen(module, events)
  end


  defp get_last_update_id do
    last_update = List.last(Telebrew.HTTP.request!("getUpdates", %{}))
    if last_update do
      last_update.update_id
    else
      0
    end
  end

  
  def polling(current_pid, last_update_id) do
    last_update = List.last(Telebrew.HTTP.request!("getUpdates", %{}))
    
    new_update = if last_update.update_id == last_update_id do nil else last_update end

    if new_update do
      send current_pid, { :update, new_update.message }
      :timer.sleep(@interval)
      polling(current_pid, new_update.update_id)
    else
      :timer.sleep(@interval)
      polling(current_pid, last_update_id)
    end
  end


  def listen(module, events) do
    receive do
      { :update, message } ->
        IO.puts "Received message: #{message.text}"
        # if the match is a command starting with / handle as command
        if String.starts_with?(message.text, "/") do
          handle_command(module, events, message)
        # if not handle as predefined event
        else
          handle_event(module, message)
        end
    end
    listen(module, events)
  end


  defp handle_command(module, events, message) do
    { cmd, msg } = split_message(message.text)
    # update text to remove command
    new_message = %{ message | text: msg }
    cmd_atom = String.to_atom(cmd)
    # find the event to call based on the command
    match = Enum.find(events, fn x -> x == cmd_atom end)
    
    cond do
      # if match exists call that function 
      match
        -> apply(module, match, [new_message])
      # if no match exists call default function
      Keyword.has_key?(module.__info__(:functions), :default)
        -> apply(module, :default, [new_message])
      # if no match and no default do nothing
      true
        -> nil
    end
  end


  defp handle_event(module, message) do
    cond do
      # if text function exists call it
      Keyword.has_key?(module.__info__(:functions), :text)
        -> apply(module, :text, [message])
      # if text function does not exist do nothing
      true
        -> nil
    end
  end


  defp split_message(message) do
    [fst|rest] = String.split(message, " ")
    { fst, Enum.join(rest, " ")}
  end

end
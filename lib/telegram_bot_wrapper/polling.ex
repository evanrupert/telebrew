defmodule TelegramBotWrapper.Polling do
  @interval unless Application.get_env(:telegram_bot_wrapper, :polling_interval), 
                   do: 1000, 
                   else: Application.get_env(:telegram_bot_wrapper, :polling_interval)
  

  def start(pid, module, events) do
    spawn(__MODULE__, :polling, [pid, 0])

    listen(module, events)
  end

  
  def polling(current_pid, last_update_id) do
    last_update = List.last(TelegramBotWrapper.HTTP.request!("getUpdates", %{}))
    
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
        text = message.text
        # find matching defined event by checking beginnning of string
        match = Enum.reduce(events, nil, fn(x, _acc) -> if String.starts_with?(text, to_string(x)) do x else nil end end)
        cond do
          # call text function if message is not a command and text function is defined
          (not String.starts_with?(text, "/")) and Keyword.has_key?(module.__info__(:functions), :text) 
            -> apply(module, :text, [message])
          # if text function is not defined then do nothing
          not String.starts_with?(text, "/")
            -> nil
          # if there is an event match than call that function
          match
            -> apply(module, match, [message])
          # if there is no match than call default function
          Keyword.has_key?(module.__info__(:functions), :default)
            -> apply(module, :default, [message])
          # if there is no default function do nothing
          true
            -> nil
        end
    end
    listen(module, events) 
  end

end
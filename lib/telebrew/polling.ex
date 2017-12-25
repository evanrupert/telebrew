defmodule Telebrew.Polling do
  @moduledoc false

  @interval unless Application.get_env(:telegram_bot_wrapper, :polling_interval),
              do: 1000,
              else: Application.get_env(:telegram_bot_wrapper, :polling_interval)

  def start(pid, module, events) do
    spawn(__MODULE__, :polling, [pid, get_last_update_id()])

    Telebrew.Listener.listen(module, events)
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

    new_update =
      if last_update.update_id == last_update_id do
        nil
      else
        last_update
      end

    if new_update do
      send(current_pid, {:update, new_update.message})
      :timer.sleep(@interval)
      polling(current_pid, new_update.update_id)
    else
      :timer.sleep(@interval)
      polling(current_pid, last_update_id)
    end
  end
end

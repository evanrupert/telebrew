defmodule Telebrew.Polling do
  use Task, restart: :permanent

  require Logger

  @interval unless Application.get_env(:telegram_bot_wrapper, :polling_interval),
              do: 1000,
              else: Application.get_env(:telegram_bot_wrapper, :polling_interval)

  @timeout_interval 200


  def run(listener_pid) do
    last_update_id = get_last_update_id()
    IO.puts "Task run with pid: #{inspect listener_pid}"

    polling(listener_pid, last_update_id)
  end

  defp get_last_update_id do
    # try to get last update, if :timeout is received try again
    try do
      last_update = List.last(Telebrew.HTTP.request!("getUpdates", %{}))
    
      if last_update do
        last_update.update_id
      else
        0
      end
    rescue
      e in Telebrew.Error ->
        Logger.error "Error: #{e.message}, trying again"
        :timer.sleep(@timeout_interval)
        get_last_update_id()       
    end
  end

  defp polling(listener_pid, last_update_id) do
    # try to poll updates, if :timeout is received try again
    try do
      last_update = List.last(Telebrew.HTTP.request!("getUpdates", %{}))

      if not is_nil(last_update) and last_update.update_id != last_update_id do
        GenServer.cast(listener_pid, {:update, last_update.message})
        :timer.sleep(@interval)
        polling(listener_pid, last_update.update_id)
      else
        :timer.sleep(@interval)
        polling(listener_pid, last_update_id)
      end
    rescue
      e in Telebrew.Error ->
        Logger.error "Error: #{e.message}, trying again"
        :timer.sleep(@timeout_interval)
        polling(listener_pid, last_update_id)
    end
  end
end
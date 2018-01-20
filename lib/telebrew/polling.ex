defmodule Telebrew.Polling do
  use Task, restart: :transient

  require Logger

  @interval unless Application.get_env(:telebrew, :polling_interval),
              do: 1000,
              else: Application.get_env(:telebrew, :polling_interval)

  @timeout_interval unless Application.get_env(:telebrew, :timeout_interval),
                      do: 200,
                      else: Application.get_env(:telebrew, :timeout_interval)

  def start_link(_args) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run do
    last_update_id = get_last_update_id()

    IO.puts("\n=================")
    IO.puts("Starting Listener")
    IO.puts("=================\n")

    polling(last_update_id)
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
        Logger.error("Error: #{e.message}, trying again")
        :timer.sleep(@timeout_interval)
        get_last_update_id()
    end
  end

  defp polling(last_update_id) do
    # try to poll updates, if :timeout is received try again
    try do
      updates = Telebrew.HTTP.request!("getUpdates", %{offset: last_update_id})
      last_update = List.last(updates)
      
      # If the last_update has not been processed then send it to the listener, else wait then poll again
      if not is_nil(last_update) and last_update.update_id != last_update_id do
        Telebrew.Listener.update(last_update.message)
        :timer.sleep(@interval)
        polling(last_update.update_id)
      else
        :timer.sleep(@interval)
        polling(last_update_id)
      end
    rescue
      e in Telebrew.Error ->
        Logger.error("Error: #{e.message}, trying again")
        :timer.sleep(@timeout_interval)
        polling(last_update_id)
    end
  end
end

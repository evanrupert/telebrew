defmodule Telebrew.Polling do
  @moduledoc """
  Handles checking telegram for updates by polling their servers with the
  get_updates function
  """
  use Task, restart: :transient

  require Logger

  # The application environment is used to make the timeout intervals optionally configurable by the user
  @timeout_interval Application.get_env(:telebrew, :timeout_interval) || 200
  @long_polling_timeout Application.get_env(:telebrew, :long_polling_timeout) || 10_000

  @telegram_wrapper Application.get_env(:telebrew, :telegram_wrapper)
  @quiet Application.get_env(:telebrew, :quiet)

  def start_link(_args) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run do
    previous_update_id = get_last_update_id()

    unless @quiet do
      IO.puts("\n=================")
      IO.puts("Starting Polling")
      IO.puts("=================\n")
    end

    polling(previous_update_id)
  end

  def get_last_update_id do
    try do
      request_last_update_with_default()
    rescue
      e in RuntimeError ->
        log_error(e)
        attempt_function_after_delay(fn -> get_last_update_id() end)
    end
  end

  defp request_last_update_with_default do
    last_update = get_last_update(0)

    if last_update do
      last_update.update_id
    else
      0
    end
  end

  defp polling(previous_update_id) do
    try do
      update_listener_if_new_update(previous_update_id)
    rescue
      e in RuntimeError ->
        log_error(e)
        attempt_function_after_delay(fn -> polling(previous_update_id) end)
    end
  end

  defp get_last_update(previous_update_id) do
    case @telegram_wrapper.get_updates(offset: previous_update_id, timeout: @long_polling_timeout) do
      {:ok, updates} ->
        List.last(updates)

      {:error, error} ->
        raise error.reason
    end
  end

  defp update_listener_if_new_update(previous_update_id) do
    last_update = get_last_update(previous_update_id)

    if last_update_is_new?(last_update, previous_update_id) do
      Telebrew.Listener.update(last_update.message)
      polling(last_update.update_id)
    else
      polling(previous_update_id)
    end
  end

  defp last_update_is_new?(last_update, previous_update_id) do
    not is_nil(last_update) and last_update.update_id != previous_update_id
  end

  defp attempt_function_after_delay(fun) do
    :timer.sleep(@timeout_interval)
    fun.()
  end

  defp log_error(e) do
    Logger.error("Error: #{e.message}, trying again")
  end
end

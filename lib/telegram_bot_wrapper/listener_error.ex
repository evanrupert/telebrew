defmodule TelegramBotWrapper.ListenerError do
  defexception message: nil

  def message(%__MODULE__{message: m}), do: inspect(m)
end
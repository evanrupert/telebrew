defmodule TelegramBotWrapper.Error do
  defexception message: nil, error_code: nil

  def message(%__MODULE__{message: m}), do: inspect(m)
  def error_code(%__MODULE__{error_code: c}), do: inspect(c)
end
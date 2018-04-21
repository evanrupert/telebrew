defmodule Telebrew.Error do
  @moduledoc """
  Stores the default error used by Telebrew
  """

  @doc """
  Default error used by Telebrew
  Contains message field with a description of what caused the error and
  the error code field which contains an error code if the error is an http
  based error
  """
  defexception message: nil, error_code: nil

  @doc """
  Returns the message field of the error
  """
  def message(%__MODULE__{message: m}), do: inspect(m)

  @doc """
  Returns the error_code field of the error
  """
  def error_code(%__MODULE__{error_code: c}), do: inspect(c)
end

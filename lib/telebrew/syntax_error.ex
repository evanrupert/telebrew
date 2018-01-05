defmodule Telebrew.SyntaxError do
  @moduledoc """
  Module that contains the main error for all event listener syntex errors
  """

  @doc """
  Main error for all event listener syntex errors

  ## Example ##
      use Telebrew.Listener
      on "/test", do: :something
      on "/test", do: :something_else
      # will result in
      == Compilation error in file lib/testing.ex ==
      ** (Telebrew.ListenerError) "Event Listener: '/test' is alread defined"
      lib/testing.ex:14: (module)
      (stdlib) erl_eval.erl:670: :erl_eval.do_apply/6
  """
  defexception message: nil

  def message(%__MODULE__{message: m}), do: inspect(m)
end

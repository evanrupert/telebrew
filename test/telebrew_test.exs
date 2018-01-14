defmodule TelebrewTest do
  use ExUnit.Case

  defmodule TestListener do
    use Telebrew

    @state :ok

    on "/test" do
      _ = state
      :ok
    end

    on ["/something", "/something_else"] do
      _ = state
      :ok
    end
  end

  test "single command generates proper function" do
    assert Keyword.has_key?(TestListener.__info__(:functions), :"/test")
    assert TestListener."/test"(nil, nil) == :ok
  end

  test "multiple command aliases generate proper functions" do
    assert Keyword.has_key?(TestListener.__info__(:functions), :"/something")
    assert Keyword.has_key?(TestListener.__info__(:functions), :"/something_else")

    assert TestListener."/something"(nil, nil) == :ok
    assert TestListener."/something_else"(nil, nil) == :ok
  end
end

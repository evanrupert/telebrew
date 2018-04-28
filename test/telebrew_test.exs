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

    on "/date" do
      m.date
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

  test "m variable is accessable in a listener" do
    assert TestListener."/date"(%{date: 1}, nil) == 1
  end

  test "duplicate listeners throw Telebrew.SyntaxError" do
    content = quote do
      use Telebrew
      on "/test", do: :ok
      on "/test", do: :ok
    end

    assert_raise Telebrew.SyntaxError, fn ->
      Module.create(BrokenTestListener, content, Macro.Env.location(__ENV__))
    end
  end

  test "empty listener throws Telebrew.SyntaxError" do
    content = quote do
      use Telebrew
      on "", do: :ok
    end

    assert_raise Telebrew.SyntaxError, fn ->
      Module.create(BrokenTestListener, content, Macro.Env.location(__ENV__))
    end
  end

  test "undefined event listener throws Telebrew.SyntaxError" do
    content = quote do
      use Telebrew
      on "unknown", do: :ok
    end

    assert_raise Telebrew.SyntaxError, fn ->
      Module.create(BrokenTestListener, content, Macro.Env.location(__ENV__))
    end
  end

  test "listener with a space in it should throw Telebrew.SyntaxError" do
    content = quote do
      use Telebrew
      on "/has space", do: :ok
    end

    assert_raise Telebrew.SyntaxError, fn ->
      Module.create(BrokenTestListener, content, Macro.Env.location(__ENV__))
    end
  end

end

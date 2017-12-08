defmodule TelegramBotWrapperTest do
  use ExUnit.Case
  doctest TelegramApi

  test "greets the world" do
    assert TelegramApi.hello() == :world
  end
end

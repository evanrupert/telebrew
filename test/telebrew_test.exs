defmodule TelebrewTest do
  use ExUnit.Case
  doctest Telebrew

  test "greets the world" do
    assert Telebrew.hello() == :world
  end
end

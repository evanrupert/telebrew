defmodule SyntaxErrorTest do
  use ExUnit.Case

  test "raised error has proper message value" do
    assert_raise Telebrew.SyntaxError, "error message", fn ->
      raise Telebrew.SyntaxError, message: "error message"
    end
  end

end

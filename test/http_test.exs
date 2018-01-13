defmodule Telebrew.HTTPTest do
  use ExUnit.Case

  import Telebrew.HTTP

  test "request returns proper info" do
    assert {:ok, message} = request("getMe", %{})
    assert message.is_bot

    assert {:error, _} = request("thisisnotamethod", %{})
  end

  test "request! returns proper info" do
    assert request!("getMe", %{}).is_bot
  
    assert_raise Telebrew.Error, fn ->
      request!("thisisnotamethod", %{})
    end
  end

  test "request! gets updates" do
    resp = request!("getUpdates", %{})

    assert is_list(resp)
  end

  test "proper responses to no api key" do
    Application.delete_env(:telebrew, :api_key)

    assert_raise Telebrew.SyntaxError, fn ->
      request("getMe", %{})
    end

    assert_raise Telebrew.SyntaxError, fn ->
      request!("getMe", %{})
    end

    Application.put_env(:telebrew, :api_key, System.get_env("TELEGRAM_API_KEY"))
  end

end
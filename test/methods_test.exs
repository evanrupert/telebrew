defmodule Telebrew.MethodsTest do
  use ExUnit.Case

  # import Telebrew.Methods

  # @test_chat 139521568
  # @test_chat2 -311965717

  # @tag :message
  # test "send_message" do
  #   assert {:ok, message} = send_message @test_chat, "test", disable_notification: true
  #   assert message.text == "test"
  #   assert_raise Telebrew.Error, fn ->
  #     send_message! :wrong_type, "test", disable_notification: true
  #   end
  # end

  # test "get_me" do
  #   assert {:ok, me} = get_me()
  #   assert me.is_bot
  # end

  # @tag :message
  # test "forward_message" do
  #   {:ok, msg} = send_message @test_chat2, "/forward_test", disable_notification: true
  #   assert {:ok, result} = forward_message @test_chat, @test_chat2, msg.message_id, disable_notification: true
  #   assert result.text == "/forward_test"

  #   assert_raise Telebrew.Error, fn ->
  #     forward_message! :wrong_type, :other_wrong_type, :yet_another_wrong_type
  #   end
  # end
end

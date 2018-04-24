defmodule Telebrew.ListenerTest do
  use ExUnit.Case

  @base_message %Nadia.Model.Message{
    audio: nil,
    caption: nil,
    channel_chat_created: nil,
    chat: %Nadia.Model.Chat{
      first_name: "John",
      id: 111_111_111,
      last_name: "Smith",
      photo: nil,
      title: nil,
      type: "private",
      username: "johnsmith"
    },
    contact: nil,
    date: 1_111_111_111,
    delete_chat_photo: nil,
    document: nil,
    edit_date: nil,
    entities: [%{length: 6, offset: 0, type: "bot_command"}],
    forward_date: nil,
    forward_from: nil,
    forward_from_chat: nil,
    from: %Nadia.Model.User{
      first_name: "John",
      id: 111_111_111,
      last_name: "Smith",
      username: "johnsmith"
    },
    group_chat_created: nil,
    left_chat_member: nil,
    location: nil,
    message_id: 1111,
    migrate_from_chat_id: nil,
    migrate_to_chat_id: nil,
    new_chat_member: nil,
    new_chat_photo: [],
    new_chat_title: nil,
    photo: [],
    pinned_message: nil,
    reply_to_message: nil,
    sticker: nil,
    supergroup_chat_created: nil,
    text: "",
    venue: nil,
    video: nil,
    voice: nil
  }

  def module_content(pid) do
    quote do
      use Telebrew

      on "/test" do
        send(unquote(pid), :text)
      end

      on "photo" do
        send(unquote(pid), :photo)
      end

      on "voice" do
        send(unquote(pid), :voice)
      end

      on "default" do
        send(unquote(pid), :default)
      end

      on "location" do
        send(unquote(pid), :location)
      end

      on "video_note" do
        send(unquote(pid), :video_note)
      end

      on "sticker" do
        send(unquote(pid), :sticker)
      end

      on "audio" do
        send(unquote(pid), :audio)
      end

      on "video" do
        send(unquote(pid), :video)
      end

      on "venue" do
        send(unquote(pid), :venue)
      end
    end
  end

  def send_test_message([{key, value}]) do
    spawn(fn ->
      msg =
        @base_message
        |> Map.put(key, value)

      # trick the listener into receiving a message
      Telebrew.Listener.update(msg)
    end)
  end

  @tag :listener
  test "commands and events are properly received" do
    Module.create(TestListener, module_content(self()), Macro.Env.location(__ENV__))

    TestListener.start()

    # Wait for the server to startup
    :timer.sleep(200)

    # Command testing
    send_test_message(text: "/test")
    assert_receive :text, 10_000

    # Photo testing
    send_test_message(
      photo: [%{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}]
    )

    assert_receive :photo, 10_000

    # Document testing
    send_test_message(
      document: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :default, 10_000

    # voice testing
    send_test_message(
      voice: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :voice, 10_000

    # video_note testing
    send_test_message(
      video_note: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :video_note, 10_000

    # audio testing
    send_test_message(
      audio: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :audio, 10_000

    # sticker testing
    send_test_message(
      sticker: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :sticker, 10_000

    # video testing
    send_test_message(
      video: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :video, 10_000

    # venue testing
    send_test_message(venue: %{title: "Some Title"})
    assert_receive :venue, 10_000

    # test default with unknown command
    send_test_message(text: "/random")
    assert_receive :default, 10_000

    # test default with unknown event
    send_test_message(text: "text_test")
    assert_receive :default, 10_000

    TestListener.stop()
  end
end

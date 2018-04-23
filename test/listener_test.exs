defmodule Telebrew.ListenerTest do
  use ExUnit.Case

  # @base_message %{
  #   chat: %{
  #     first_name: "Evan",
  #     id: 139_521_568,
  #     last_name: "Rupert",
  #     type: "private",
  #     username: "Eguy45"
  #   },
  #   date: 1_515_815_296,
  #   entities: [%{length: 5, offset: 0, type: "bot_command"}],
  #   from: %{
  #     first_name: "Evan",
  #     id: 139_521_568,
  #     is_bot: false,
  #     language_code: "en-US",
  #     last_name: "Rupert",
  #     username: "Eguy45"
  #   },
  #   message_id: 1031
  # }

  @base_message %Nadia.Model.Message{
    audio: nil,
    caption: nil,
    channel_chat_created: nil,
    chat: %Nadia.Model.Chat{
      first_name: "Evan",
      id: 139_521_568,
      last_name: "Rupert",
      photo: nil,
      title: nil,
      type: "private",
      username: "Eguy45"
    },
    contact: nil,
    date: 1_524_448_558,
    delete_chat_photo: nil,
    document: nil,
    edit_date: nil,
    entities: [%{length: 6, offset: 0, type: "bot_command"}],
    forward_date: nil,
    forward_from: nil,
    forward_from_chat: nil,
    from: %Nadia.Model.User{
      first_name: "Evan",
      id: 139_521_568,
      last_name: "Rupert",
      username: "Eguy45"
    },
    group_chat_created: nil,
    left_chat_member: nil,
    location: nil,
    message_id: 1494,
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

  setup_all do
    Module.create(TestListener, module_content(self()), Macro.Env.location(__ENV__))

    TestListener.start()

    # Wait for the server to startup
    :timer.sleep(200)

    :ok
  end

  @tag :listener
  test "/test command is processed by the listener" do
    send_test_message(text: "/test")
    assert_receive :text, 10_000
  end

  @tag :listener
  test "photo event is processed by the listener" do
    send_test_message(
      photo: [%{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}]
    )

    assert_receive :photo, 10_000
  end

  @tag :listener
  test "document event is processed by the listener" do
    send_test_message(
      document: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :default, 10_000
  end

  @tag :listener
  test "voice event is processed by the listener" do
    send_test_message(
      voice: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :voice, 10_000
  end

  @tag :listener
  test "video_note event is processed by the listener" do
    send_test_message(
      video_note: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :video_note, 10_000
  end

  @tag :listener
  test "audio event is processed by the listener" do
    send_test_message(
      audio: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :audio, 10_000
  end

  @tag :listener
  test "sticker event is processed by the listener" do
    send_test_message(
      sticker: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :sticker, 10_000
  end

  @tag :listener
  test "video event is processed by the listener" do
    send_test_message(
      video: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :video, 10_000
  end

  @tag :listener
  test "venue event is processed by the listener" do
    send_test_message(venue: %{title: "Some Title"})
    assert_receive :venue, 10_000
  end

  @tag :listener
  test "default is called when given unknown command" do
    send_test_message(text: "/random")
    assert_receive :default, 10_000
  end

  @tag :listener
  test "default is called against unknown event" do
    send_test_message(text: "text_test")
    assert_receive :default, 10_000
  end
end

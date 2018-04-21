defmodule Telebrew.ListenerTest do
  use ExUnit.Case

  @base_message %{
    chat: %{
      first_name: "Evan",
      id: 139_521_568,
      last_name: "Rupert",
      type: "private",
      username: "Eguy45"
    },
    date: 1_515_815_296,
    entities: [%{length: 5, offset: 0, type: "bot_command"}],
    from: %{
      first_name: "Evan",
      id: 139_521_568,
      is_bot: false,
      language_code: "en-US",
      last_name: "Rupert",
      username: "Eguy45"
    },
    message_id: 1031
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
      # wait for server to startup
      :timer.sleep(200)

      msg =
        @base_message
        |> Map.put(key, value)

      # trick the listener into receiving a message
      Telebrew.Listener.update(msg)
    end)
  end

  @tag :listener
  test "events and commands work" do
    Module.create(TestListener, module_content(self()), Macro.Env.location(__ENV__))

    TestListener.start()

    # test command
    send_test_message(text: "/test")
    assert_receive :text, 10_000

    # test photo event
    send_test_message(
      photo: [%{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}]
    )

    assert_receive :photo, 10_000

    # test document event
    send_test_message(
      document: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :default, 10_000

    # test voice event
    send_test_message(
      voice: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :voice, 10_000

    # test video_note event
    send_test_message(
      video_note: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :video_note, 10_000

    # test location event
    send_test_message(location: %{latitude: 20, longitude: 20})
    assert_receive :location, 10_000

    # test audio event
    send_test_message(
      audio: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :audio, 10_000

    # test sticker event
    send_test_message(
      sticker: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :sticker, 10_000

    # test video event
    send_test_message(
      video: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :video, 10_000

    # test default for a command
    send_test_message(text: "/random")
    assert_receive :default, 10_000

    # test venue event
    send_test_message(venue: %{title: "Some Title"})
    assert_receive :venue, 10_000

    # test default against text event
    send_test_message(text: "text_test")
    assert_receive :default, 10_000
  end
end

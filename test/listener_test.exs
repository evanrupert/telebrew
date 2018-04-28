defmodule Telebrew.ListenerTest do
  use ExUnit.Case

  alias Telebrew.Listener.{Data, State}

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

  def send_test_message([{key, value}]) do
    spawn(fn ->
      msg =
        @base_message
        |> Map.put(key, value)

      # trick the listener into receiving a message
      Telebrew.Listener.update(msg)
    end)
  end

  def create_and_start_module(code) do
    Module.create(TestListener, code, Macro.Env.location(__ENV__))

    TestListener.start()
  end

  def cleanup_listener_test do
    TestListener.stop()
  end

  test "command listening properly executes code" do
    create_and_start_module(
      quote do
        use Telebrew
        on "/test", do: send(unquote(self()), :text)
      end
    )

    send_test_message(text: "/test")

    assert_receive :text, 2_000

    cleanup_listener_test()
  end

  test "photo listener works" do
    create_and_start_module(
      quote do
        use Telebrew
        on "photo", do: send(unquote(self()), :photo)
      end
    )
    send_test_message(
      photo: [%{file_id: "agadaqadvkcxgzsuyeafaysechlxzwl6ddaabpfpnmzjdksjmv4aagi"}]
    )

    assert_receive :photo, 2_000

    cleanup_listener_test()
  end

  test "document listener works" do
    create_and_start_module(
      quote do
        use Telebrew
        on "document", do: send(unquote(self()), :document)
      end
    )

    send_test_message(
      document: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :document, 2_000

    cleanup_listener_test()
  end

  test "voice listener works" do
    create_and_start_module(
      quote do
        use Telebrew
        on "voice", do: send(unquote(self()), :voice)
      end
    )

    send_test_message(
      voice: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :voice, 2_000

    cleanup_listener_test()
  end

  test "video_note listener works" do
    create_and_start_module(
      quote do
        use Telebrew
        on "video_note", do: send(unquote(self()), :video_note)
      end
    )

    send_test_message(
      video_note: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :video_note, 2_000

    cleanup_listener_test()
  end

  test "audio listener works" do
    create_and_start_module(
      quote do
        use Telebrew
        on "audio", do: send(unquote(self()), :audio)
      end
    )

    send_test_message(
      audio: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :audio, 2_000

    cleanup_listener_test()
  end

  test "video listener works" do
    create_and_start_module(
      quote do
        use Telebrew
        on "video", do: send(unquote(self()), :video)
      end
    )

    send_test_message(
      video: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :video, 2_000

    cleanup_listener_test()
  end

  test "sticker listener works" do
    create_and_start_module(
      quote do
        use Telebrew
        on "sticker", do: send(unquote(self()), :sticker)
      end
    )

    send_test_message(
      sticker: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :sticker, 2_000

    cleanup_listener_test()
  end

  test "venue listener works" do
    create_and_start_module(
      quote do
        use Telebrew
        on "venue", do: send(unquote(self()), :venue)
      end
    )

    send_test_message(venue: %{title: "Some Title"})

    assert_receive :venue, 2_000

    cleanup_listener_test()
  end

  test "location listener works" do
    create_and_start_module(
      quote do
        use Telebrew
        on "location", do: send(unquote(self()), :location)
      end
    )

    send_test_message(location: %{longitude: 20, latitude: 20})

    assert_receive :location, 2_000
  end

  test "contact listener works" do
    create_and_start_module(
      quote do
        use Telebrew
        on "contact", do: send(unquote(self()), :contact)
      end
    )

    send_test_message(contact: %{first_name: "Name"})

    assert_receive :contact, 2_000
  end

  test "default function is called if event listener not defined" do
    create_and_start_module(
      quote do
        use Telebrew
        on "default", do: send(unquote(self()), :default)
      end
    )

    send_test_message(
      document: %{file_id: "AgADAQADvKcxGzsuyEafayseChLXzWl6DDAABPfPNmzjDkSjmV4AAgI"}
    )

    assert_receive :default, 2_000

    cleanup_listener_test()
  end

  test "default function is called if given an unknown command" do
    create_and_start_module(
      quote do
        use Telebrew
        on "default", do: send(unquote(self()), :default)
      end
    )

    send_test_message(text: "/unknown")

    assert_receive :default, 2_000

    cleanup_listener_test()
  end

  # test "message object can be accessed in listener" do
  #   create_and_start_module(
  #     quote do
  #       use Telebrew
  #       on "/m" do
  #         date = m.date
  #         send(unquote(self()), {:date, date})
  #       end
  #     end
  #   )

  #   send_test_message(text: "/m")

  #   assert_receive {:date, 1_111_111_111}, 2_000

  #   cleanup_listener_test()
  # end

  test "update_add_chat_states works" do
    data = %Data{module: nil, listeners: [], state: %State{
                     initial: 0,
                     all_chats: %{
                       1 => 0,
                       2 => 1
                     },
                     current_chat: nil
                  }}
    new_state = %{
      1 => 1,
      2 => 2
    }

    updated_data = Data.update_all_chat_states(data, new_state)

    assert updated_data.state.all_chats == new_state
  end
end

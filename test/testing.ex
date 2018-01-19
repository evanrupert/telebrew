defmodule Testing do
  use Telebrew

  on "/test" do
    send_message(m.chat.id, "System is up")
  end

  on "/kick" do
    {user_id, _} = Integer.parse(m.text)
    IO.inspect(kick_chat_member(m.chat.id, user_id))
  end

  on "/unban" do
    {user_id, _} = Integer.parse(m.text)

    IO.inspect(unban_chat_member(m.chat.id, user_id))
  end

  on "/link" do
    link = export_chat_invite_link!(m.chat.id)

    send_message m.chat.id, link
  end

  on "/pin" do
    pin_chat_message!(m.chat.id, m.message_id)
  end

  on "/unpin" do
    unpin_chat_message!(m.chat.id)
  end

  on "/leave" do
    leave_chat m.chat.id
  end

  on "/print_info" do
    IO.inspect get_chat!(m.chat.id)
  end

  on "/administrators" do
    get_chat_administrators!(m.chat.id)
    |> Enum.map(&IO.inspect/1)
  end

  on "/count" do
    count = get_chat_members_count!(m.chat.id)

    send_message m.chat.id, count
  end

  on "/print_me" do
    IO.inspect get_chat_member!(m.chat.id, m.from.id)
  end

  on "default" do
    IO.inspect(m)
  end
end

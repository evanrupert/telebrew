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

  on "default" do
    IO.inspect(m)
  end
end

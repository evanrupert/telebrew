defmodule Testing do
  use Telebrew.Listener

  on "/test" do
    send_message(m.chat.id, "System is working")
  end

  on "text", when: String.length(m.text) == 5 do
    send_message(m.chat.id, "That message is five characters long")
  end
end

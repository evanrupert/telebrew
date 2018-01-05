defmodule Testing do
  use Telebrew

  on ["/test", "/t"] do
    send_message m.chat.id, "System is up"
  end
end

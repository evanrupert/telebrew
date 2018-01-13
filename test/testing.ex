defmodule Testing do
  use Telebrew

  on "/test" do
    send_message m.chat.id, "System is up"
  end

  on "default" do
    send_message m.chat.id, "Got default"
    IO.inspect m
  end

  on "photo" do
    send_message m.chat.id, "Received photo"
  end

end

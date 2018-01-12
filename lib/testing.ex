defmodule Testing do
  use Telebrew

  on "/test" do
    send_message(m.chat.id, "System is up")
  end

  on "photo" do
    send_message m.chat.id, "You received a photo"
  end

  on "default" do
    send_message m.chat.id, "Something else happened"
  end
  
end

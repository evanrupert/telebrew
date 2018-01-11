defmodule Testing do
  use Telebrew

  on "/test" do
    send_message m.chat.id, "System is up"
  end

  on "location" do
    send_message m.chat.id, "You are at: (#{m.location.latitude}, #{m.location.longitude})"
  end

end

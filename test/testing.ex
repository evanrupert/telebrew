defmodule Testing do
  use Telebrew

  on "/test" do
    send_message(m.chat.id, "System is up")
  end

  on "location" do
    send_message m.chat.id, "Received a location"
  end

  on "venue" do
    send_message m.chat.id, "Received a venue"
  end

  on "/get_venue" do
    send_venue m.chat.id, 
               20.0, 
               20.0, 
               "Party", 
               "2968 Majestic Isle Dr",
               disable_notification: true
  end

  on "default" do
    IO.inspect m
  end

end

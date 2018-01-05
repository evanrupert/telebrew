defmodule Testing do
  use Telebrew

  on "/test" do
    send_message m.chat.id, "System is up"
  end

  on ["photo", "video", "video_note"] do
    send_message m.chat.id, "Received visual format"
  end

  on ["audio", "voice"] do
    send_message m.chat.id, "Received audio format"
  end
  
end
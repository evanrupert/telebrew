defmodule Testing do
  use Telebrew

  on "/test" do
    send_message(m.chat.id, "System is up")
  end

  on "photo" do
    photo = List.first m.photo
    
    send_photo! m.chat.id, photo.file_id, caption: "Echo"
  end

  on "sticker" do
    send_message m.chat.id, "Received sticker"
  end

  on "audio" do
    send_audio m.chat.id, m.audio.file_id, caption: "Echo"
  end

end

defmodule Testing do
  use Telebrew

  on "/test" do
    send_message m.chat.id, "System is up"
  end

  on "text" do
    send_message m.chat.id, "Received text"
  end

  on "video_note" do
    send_video_note m.chat.id, m.video_note.file_id
  end

  on "voice" do
    send_voice m.chat.id, m.voice.file_id
  end

  on "photo" do
    send_message m.chat.id, "Received photo"
  end

  on "sticker" do
    send_message m.chat.id, "Received sticker"
  end

  on "audio" do
    send_voice m.chat.id, m.audio.file_id, caption: "Voiceified"
  end

  on "document" do
    send_message m.chat.id, "Document received" 
  end

end

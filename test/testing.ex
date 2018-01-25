defmodule Testing do
  use Telebrew

  on "/test", do: respond "System is up"

  on "/edit" do
    spawn fn ->
      msg = respond! "Original text"
      Process.sleep(2000)
      edit_message_text("Edited text", chat_id: m.chat.id, message_id: msg.message_id)
    end
  end

  on "/edit_caption" do
    img = "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Pacific_walrus_bull_odobenus_rosmarus.jpg/1200px-Pacific_walrus_bull_odobenus_rosmarus.jpg"
    spawn fn ->
      {:ok, msg} = send_photo(m.chat.id, img, caption: "Original caption")
      :timer.sleep(2000)
      edit_message_caption(caption: "Edited caption", chat_id: m.chat.id, message_id: msg.message_id)      
    end
  end

  on "/delete" do
    spawn fn ->
      {:ok, msg} = respond "Message to be deleted"
      :timer.sleep(2000)
      delete_message!(m.chat.id, msg.message_id)
    end
  end

  on "sticker" do
    send_sticker(m.chat.id, m.sticker.file_id)
  end

end

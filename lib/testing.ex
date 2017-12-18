defmodule Testing do
  use Telebrew.Listener

  on "photo" do
    photos = m.photo
    for %{"file_id" => file_id} <- photos do
      send_photo m.chat.id, file_id
    end
  end


  on "/test" do
    send_message m.chat.id, "System is working"
  end


end
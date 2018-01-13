defmodule Testing do
  use Telebrew

  on "/test" do
    send_message m.chat.id, "System is up"
  end

  on "/get_contact" do
    send_contact m.chat.id, "1234567890", "Jimmy"
  end

  on "/do" do
    send_chat_action m.chat.id, "typing"
  end

  on "contact" do
    send_contact! m.chat.id, m.contact.phone_number, m.contact.first_name
  end

  on "default" do
    send_message m.chat.id, "Got default"
    IO.inspect m
  end

end

defmodule Testing do
  use TelegramBotWrapper.Listener


  on "/test" do
    send_message(m.chat.id, "Test command called with message: #{m.text}")
  end


  on "/something", as: :message do
    send_message(message.chat.id, "Something command called with message: #{message.text}")
  end


  on "text" do
    send_message(m.chat.id, "Text was called with message: #{m.text}")
  end

end
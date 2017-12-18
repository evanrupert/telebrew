defmodule Testing do
  use TelegramBotWrapper.Listener

  on "/something" do
    send_message m.chat.id, "Something listener with Text: \'#{m.text}\'"
  end


  on "/test" do
    send_message(m.chat.id, "Test listener with Text: \'#{m.text}\'")
  end


  on "/test2" do
    send_message m.chat.id, "Test2 listener with Text: \'#{m.text}\'"
  end


  on "/test3" do
    send_message m.chat.id, "Test3 listener with Text: \'#{m.text}\'"
  end


  on "/stuff" do
    send_message m.chat.id, "Stuff listener with Text: \'#{m.text}\'"
  end


  on "text" do
    send_message(m.chat.id, "Text listener with Text: \'#{m.text}\'")
  end


  on "default" do
    send_message m.chat.id, "Default listener with Text: \'#{m.text}\'"
  end

end
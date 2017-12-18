defmodule Testing do
  use Telebrew.Listener

  on "/something" do
    send_message m.chat.id, "Something listener with Text: \'#{m.text}\'"
  end


  on "/test" do
    send_message m.chat.id, "Test listener with Text: \'#{m.text}\'"
  end


  on "text" do
    send_message m.chat.id, "Text listener with Text: \'#{m.text}\'"
  end


  on "default" do
    send_message m.chat.id, "Default listener with Text: \'#{m.text}\'"
  end

end
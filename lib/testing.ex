defmodule Testing do
  use Telebrew.Listener

  on "/test" do
    send_message m.chat.id, "System is working"
  end


  on "/timer" do
    :timer.sleep(10000)
    send_message m.chat.id, "It has been ten seconds"
  end


  on "/exception" do
    raise "This is an exception"
  end

end
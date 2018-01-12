defmodule Testing do
  use Telebrew

  on "/test" do
    send_message(m.chat.id, "System is up")
  end

  on "default" do
    IO.inspect(m)
  end
end

defmodule Testing do
  use Telebrew

  @help :help

  on ~w(/t /test) do
    send_message(m.chat.id, "System is up")
  end

  on "/#{@help}" do
    send_message(m.chat.id, "Some help message")
  end

  on "default" do
    IO.inspect(m)
  end

end

defmodule Testing do
  use Telebrew

  @init 0

  on "/increase" do
    state + 1
  end

  on "/decrease" do
    state - 1
  end

  on "/get" do
    send_message m.chat.id, state
    state
  end

end

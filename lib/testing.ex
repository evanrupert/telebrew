defmodule Testing do
  @moduledoc false
  use Telebrew

  on "/test", do: respond "System is up"

  on "/echo" do
    send_message m.chat.id, m.text
  end

end

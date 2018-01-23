defmodule Testing do
  use Telebrew

  on "/echo"  do
    send_message(m.chat.id, "Longer than ten")
  end

end

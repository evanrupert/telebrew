defmodule Testing do
  use Telebrew

  @init []

  on "/test" do
    send_message m.chat.id, "System is up"

    state
  end

  on "/add" do
    send_message m.chat.id, "Item added"

    [ m.text | state ]
  end

  on "/remove" do
    send_message m.chat.id, "Last item removed"

    [ _ | t ] = state
    t 
  end

  on "/list" do
    send_message m.chat.id, "ALL ITEMS"
    
    for item <- Enum.reverse(state) do
      send_message m.chat.id, item
    end

    state
  end
end

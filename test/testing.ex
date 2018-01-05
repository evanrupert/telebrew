defmodule Testing do
  use Telebrew

  @init 0

  on "/test" do
    send_message m.chat.id, "System is up"
    
    state
  end

  on ["/get", "/g"] do
    send_message m.chat.id, state
    
    state
  end

  on ["/increase", "/i"] do
    send_message m.chat.id, "State increased"

    state + 1
  end

  on ["/decrease", "/d"] do
    send_message m.chat.id, "State decreased"

    state - 1
  end
  
end
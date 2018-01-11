defmodule Testing do
  use Telebrew

  @state nil

  on "/test" do
    send_message m.chat.id, "System is up"

    state
  end

  on "/set" do
    m.text
  end

  on "/get" do
    send_message m.chat.id, state

    state
  end

  on "/break" do
    raise Telebrew.Error, message: "You broke it"
  end

  on "/wait" do
    {time, _} = Integer.parse(m.text)
    :timer.sleep(time)

    state
  end

end

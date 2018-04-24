defmodule Testing do
  @moduledoc false
  use Telebrew

  on "/test", do: respond "System is up"

  on "/echo", do: respond m.text

  on "/reverse", do: respond(String.reverse(m.text))

  on "/print" do
    IO.inspect m
  end

end

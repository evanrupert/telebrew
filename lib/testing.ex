defmodule Testing do
  use Telebrew

  on "/test", do: respond "System is up"

  on "echo" do
    respond m.text
  end
end

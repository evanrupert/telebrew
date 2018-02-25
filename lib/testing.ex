defmodule Testing do
  use Telebrew

  on "/test", do: respond "System is up"

end

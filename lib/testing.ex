defmodule Testing do
  @moduledoc false
  use Telebrew

  on "/test", do: respond "System is up"

  on "/date", do: respond m.date

  on "/something" do
    respond "Doing something"
  end

  on "/something_else" do
    respond "Doing something else"
  end

end

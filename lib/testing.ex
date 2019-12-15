defmodule Testing do
  @moduledoc false
  use Telebrew

  # TODO: Fix tests
  # TODO: Figure out ElixirLs warning on macros

  on "/hello" do
    respond "World"
  end

  on "/ping", do: respond "Pong"

end

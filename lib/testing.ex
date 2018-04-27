defmodule Testing do
  @moduledoc false
  use Telebrew

  @state 0

  on "/test" do
    respond "System is up"

    state
  end

  on "/get" do
    respond state

    state
  end

  on "/inc" do
    state + 1
  end

end

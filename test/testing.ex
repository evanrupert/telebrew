defmodule Testing do
  use Telebrew

  @state 0

  on ~w(/t /test) do
    respond "System is up"
    
    state
  end

  on "/get" do
    respond state

    state
  end

  on "/increase" do
    state + 1
  end

  on "/decrease" do
    state - 1
  end

  on "default" do
    IO.inspect(m)

    state
  end
end

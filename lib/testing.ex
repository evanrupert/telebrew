defmodule Testing do
  @moduledoc false
  use Telebrew

  on "/test", do: respond "System is up"

  on "/print" do
    IO.inspect m
  end

end

defmodule PollingTest do
  use ExUnit.Case

  import Telebrew.Polling

  test "get_last_update_id returns proper value" do
    assert 111_111_111 == get_last_update_id()
  end

end

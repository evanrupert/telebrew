defmodule PollingTest do
  use ExUnit.Case

  import Telebrew.Polling

  test "get_last_update_id returns proper value" do
    assert 111_111_111 == get_last_update_id()
  end

  test "mock wrapper returns proper update" do
    assert {:ok, [update|_]} = Telebrew.Test.MockWrapper.get_updates(111_111_110)

    assert update.update_id == 111_111_111
  end

end

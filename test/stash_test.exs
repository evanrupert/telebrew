defmodule Telebrew.StashTest do
  use ExUnit.Case

  @state 1
  @new_state 2

  test "stash works" do
    assert {:ok, _} = Telebrew.Stash.start_link(@state)

    assert @state == Telebrew.Stash.get_state()

    Telebrew.Stash.save_state(@new_state)

    assert @new_state == Telebrew.Stash.get_state()
  end
end

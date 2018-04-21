defmodule Telebrew.Listener.Data do
  @moduledoc """
  Provides the struct representation of all the data that the listener needs to keep track of
  """
  alias Telebrew.Listener.State
  defstruct module: nil, listeners: [], state: %State{}

  def update_current_chat_state(data, chat_id, new_state) do
    updated_state = State.update_current_chat_state(data.state, chat_id, new_state)
    %{data | state: updated_state}
  end

  def update_all_chat_states(data, new_state) do
    updated_state = State.update_all_chat_states(data.state, new_state)
    %{data | state: updated_state}
  end
end

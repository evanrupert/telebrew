defmodule Telebrew.Listener.State do
  @moduledoc """
  Defines the struct used for storing the state of the chats
  """

  defstruct initial: nil, all_chats: %{}, current_chat: nil

  def update_current_chat_state(state_struct, chat_id, new_state) do
    updated_all_chats = Map.put(state_struct.all_chats, chat_id, new_state)
    %{state_struct | all_chats: updated_all_chats}
  end

  def update_all_chat_states(state_struct, new_state) do
    %{state_struct | all_chats: new_state}
  end
end

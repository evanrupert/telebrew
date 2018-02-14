defmodule Telebrew.Listener.State do
  defstruct initial: nil, all_chats: %{}, current_chat: nil

  def update_current_chat_state(state_struct, chat_id, new_state) do
    Map.put(state_struct, chat_id, new_state)
  end

  def update_all_chat_states(state_struct, new_state) do
    %{state_struct | all_chats: new_state}
  end
end
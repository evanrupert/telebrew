defmodule Telebrew.Test.MockWrapper do
  @moduledoc false

  @sample_update %Nadia.Model.Update{
     callback_query: nil,
     channel_post: nil,
     chosen_inline_result: nil,
     edited_message: nil,
     inline_query: nil,
     message: %Nadia.Model.Message{
       audio: nil,
       caption: nil,
       channel_chat_created: nil,
       chat: %Nadia.Model.Chat{
         first_name: "John",
         id: 111_111_111,
         last_name: "Smith",
         photo: nil,
         title: nil,
         type: "private",
         username: "johnsmith"
       },
       contact: nil,
       date: 1_111_111_111,
       delete_chat_photo: nil,
       document: nil,
       edit_date: nil,
       entities: [%{length: 8, offset: 0, type: "bot_command"}],
       forward_date: nil,
       forward_from: nil,
       forward_from_chat: nil,
       from: %Nadia.Model.User{
         first_name: "John",
         id: 111_111_111,
         last_name: "Smith",
         username: "johnsmith"
       },
       group_chat_created: nil,
       left_chat_member: nil,
       location: nil,
       message_id: 1509,
       migrate_from_chat_id: nil,
       migrate_to_chat_id: nil,
       new_chat_member: nil,
       new_chat_photo: [],
       new_chat_title: nil,
       photo: [],
       pinned_message: nil,
       reply_to_message: nil,
       sticker: nil,
       supergroup_chat_created: nil,
       text: "",
       venue: nil,
       video: nil,
       voice: nil
     },
     update_id: 111_111_111
   }


  def get_updates(_) do
    {:ok, [@sample_update]}
  end

end

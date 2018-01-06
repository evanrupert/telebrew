defmodule Testing do
  use Telebrew

  @state %{}

  on "/test" do
    send_message m.chat.id, "System is up" 

    state
  end

  on "/random" do
    {lat, lon} = random_coordinets()

    msg = send_location! m.chat.id, lat, lon, live_period: 60

    Map.put(state, :loc_message_id, msg.message_id)
  end

  on "/update" do
    {lat, lon} = random_coordinets()

    if Map.has_key?(state, :loc_message_id) do
      edit_message_live_location lat, lon, chat_id: m.chat.id, message_id: state.loc_message_id
    else
      send_message m.chat.id, "Random location has not been started use '/random'"      
    end

    state
  end

  on "/get" do
    if Map.has_key?(state, :loc_message_id) do
      send_message m.chat.id, state.loc_message_id
    else
      send_message m.chat.id, "Random location has not been started use '/random'"  
    end
    
    state
  end

  on "/stop" do
    if Map.has_key?(state, :loc_message_id) do
      stop_message_live_location(chat_id: m.chat.id, message_id: state.loc_message_id)

      Map.delete(state, :loc_message_id)
    else
      send_message m.chat.id, "Random location has not been started use '/random'"
      
      state
    end
  end

  def random_coordinets do
    lat = (:rand.uniform() * 180) - 90
    lon = (:rand.uniform() * 360) - 180
    {lat, lon} 
  end

end

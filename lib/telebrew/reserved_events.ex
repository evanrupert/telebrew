defmodule Telebrew.ReservedEvents do
  
  @reserved_events [
    :text,
    :photo,
    :sticker,
    :audio,
    :document,
    :video,
    :video_note,
    :voice,
    :venue,
    :location,
    :contact,
    :default
  ]

  def get do
    @reserved_events
  end

  def contains?(event) do
    Enum.member?(@reserved_events, event)
  end

  def find(event) do
    Enum.find(@reserved_events, fn x -> x == event end)
  end

end
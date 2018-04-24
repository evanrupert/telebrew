defmodule Telebrew.ReservedEvents do
  @moduledoc """
  Is used to store the reserved events list
  """

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

end

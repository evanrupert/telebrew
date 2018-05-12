defmodule Telebrew.Websocket.Handler do
  @moduledoc """
  Module for handling cowboy requests
  """
  @behaviour :cowboy_websocket

  @quiet Application.get_env(:telebrew, :quiet)


  def init(req, state) do
    {:cowboy_websocket, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end

  def websocket_handle(message, _req, state) do
    IO.inspect message
    {:ok, state}
  end

  def websocket_info(_info, _req, state) do
    {:ok, state}
  end

end

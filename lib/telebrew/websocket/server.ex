defmodule Telebrew.Websocket.Server do
  @moduledoc """
  Defines a task for starting a cowboy server
  """

  use Task, restart: :transient

  require Logger

  def start_link(_args) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run do
    dispatch_config = :cowboy_router.compile([
      { :_,
        [
          { :_, Telebrew.Websocket.Handler, []}
        ]
      }
    ])

    :cowboy.start_http(:http, 100,[{:port, 8080}],[{ :env, [{:dispatch, dispatch_config}]}])
  end
end

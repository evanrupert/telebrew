defmodule Telebrew.Application do
  @moduledoc false
  use Application

  @listener_module Application.get_env(:telebrew, :listener_module)


  def start(_type, _args) do
    unless @listener_module do
      raise "listener_module is not defined, please define it in your config file"
    end

    @listener_module.start()
  end

end


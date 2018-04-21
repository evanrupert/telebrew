defmodule Telebrew.Stash do
  @moduledoc """
  Is used for storing the state of the bots in case
  the listener process crashes for whatever reason
  """
  use GenServer

  # Client

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def save_state(state) do
    GenServer.cast(__MODULE__, {:save, state})
  end

  def get_state do
    GenServer.call(__MODULE__, :get)
  end

  # Server Callbacks

  @impl true
  def init(args) do
    {:ok, args}
  end

  @impl true
  def handle_cast({:save, state}, _) do
    {:noreply, state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end

defmodule Pewpew.Player do
  use GenServer
  # TODO add struct 

  ## Client API

  def start_link(player) do
    GenServer.start_link(__MODULE__, {:ok, player})
  end

  def health(player_pid) do
    GenServer.call(player_pid, {:health})
  end

  def damage(player_pid, damage) do
    GenServer.call(player_pid, {:damage, damage})
  end

  def is_alive?(player_pid) do
    GenServer.call(player_pid, {:is_alive?})
  end

  ## Server Callbacks

  def init({:ok, player}) do
    {:ok, player}
  end

  def handle_call({:health}, _from, player) do
    {:reply, Map.get(player, :health), player}
  end

  def handle_call({:damage, damage}, _from, player) do
    new_health = Map.get(player, :health) - damage
    {:reply, new_health, Map.put(player, :health, new_health)}
  end

  def handle_call({:is_alive?}, _from, player) do
    {:reply, Map.get(player, :health) > 0.0, player}
  end

end
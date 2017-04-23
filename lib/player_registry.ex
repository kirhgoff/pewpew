defmodule Pewpew.PlayerRegistry do
  use GenServer

  ## Client API

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def lookup(registry_pid, name) do
    GenServer.call(registry_pid, {:lookup, name})
  end

  def create(registry_pid, player) do
    GenServer.call(registry_pid, {:create, player})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:lookup, name}, _from, players) do
    {:reply, Map.get(players, name), players}
  end

  def handle_call({:create, player}, _from, players) do
    name = Map.get(player, :name)
    if Map.has_key?(players, name) do
      {:error, players}
    else
      {:ok, player} = Pewpew.Player.start_link(player)
      {:reply, player, Map.put(players, name, player)}
    end
  end
end
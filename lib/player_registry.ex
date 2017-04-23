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

  def stop(registry_pid) do
    GenServer.stop(registry_pid)
  end

  ## Server Callbacks

  def init(:ok) do
    players = %{}
    refs = %{}
    {:ok, {players, refs}}
  end

  def handle_call({:lookup, name}, _from, {players, _} = state) do
    {:reply, Map.get(players, name), state}
  end

  def handle_call({:create, player}, _from, {players, refs}) do
    name = Map.get(player, :name)
    if Map.has_key?(players, name) do
      {:error, {players, refs}}
    else
      {:ok, player} = Pewpew.Player.start_link(player)
      ref = Process.monitor(player)
      players = Map.put(players, name, player)
      refs = Map.put(refs, ref, name)
      {:reply, player, {players, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {players, refs}) do
    {name, refs} = Map.pop(refs, ref)
    players = Map.delete(players, name)
    {:noreply, {players, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end